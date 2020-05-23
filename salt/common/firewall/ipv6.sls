{% set firewall = salt['pillar.get']('firewall') %}

iptables6_base_chain:
  iptables.chain_present:
    - name: salt-base
    - family: ipv6
    - require:
      - pkg: install_base_packages

# create chains
{% for chain in ['system', 'block-host', 'allow-host', 'roles', 'block-global', 'allow-global'] %}
iptables6_{{ chain }}_chain:
  iptables.chain_present:
    - name: salt-{{ chain }}
    - family: ipv6
    - require:
      - pkg: install_base_packages
{% endfor %}

{% if firewall.enabled %}

iptables6_base_rule:
  iptables.append:
    - family: ipv6
    - chain: INPUT
    - jump: salt-base
    - save: True
    - require:
      - iptables: iptables6_base_chain

# build rules in base chain
{% for chain, reqs in {
  'system': ['system_chain'],
  'block-host':   ['block-host_chain', 'base_system_rule'],
  'allow-host':   ['allow-host_chain', 'base_block-host_rule'],
  'roles':        ['roles_chain', 'base_allow-host_rule'],
  'block-global': ['block-global_chain', 'base_allow-host_rule'],
  'allow-global': ['allow-global_chain', 'base_block-global_rule']
}.items() %}
iptables6_base_{{ chain }}_rule:
  iptables.append:
    - family: ipv6
    - chain: salt-base
    - jump: salt-{{ chain }}
    - save: True
    - require:
      - iptables: iptables6_base_chain
      {% for req in reqs %}
      - iptables: iptables6_{{ req }}
      {% endfor %}
{% endfor %}

iptables6_system_allow_established:
  iptables.append:
    - family: ipv6
    - chain: salt-system
    - match: conntrack
    - ctstate: RELATED,ESTABLISHED
    - jump: ACCEPT
    - save: True
    - require:
      - iptables: iptables6_system_chain
      - iptables: iptables6_base_system_rule

iptables6_system_allow_localhost:
  iptables.append:
    - family: ipv6
    - chain: salt-system
    - in-interface: lo+
    - jump: ACCEPT
    - save: True
    - require:
      - iptables: iptables6_system_allow_established

iptables6_system_block_bad_loopback_src:
  iptables.append:
    - family: ipv6
    - chain: salt-system
    - in-interface: '!lo+'
    - source: ::1/128
    - jump: DROP
    - require:
      - iptables: iptables6_system_allow_localhost

iptables6_system_block_bad_loopback_dst:
  iptables.append:
    - family: ipv6
    - chain: salt-system
    - in-interface: '!lo+'
    - destination: ::1/128
    - jump: DROP
    - require:
      - iptables: iptables6_system_block_bad_loopback_src

iptables6_system_block_invalid:
  iptables.append:
    - family: ipv6
    - chain: salt-system
    - match: conntrack
    - ctstate: INVALID
    - jump: DROP
    - save: True
    - require:
      - iptables: iptables6_system_block_bad_loopback_dst

iptables6_ping:
  {% if firewall.ping %}
  iptables.append:
  {% else %}
  iptables.delete:
  {% endif %}
    - family: ipv6
    - chain: salt-system
    - proto: icmpv6
    - icmpv6-type: echo-request
    - jump: ACCEPT
    - save: True
    - require:
      - iptables: iptables6_system_block_invalid

# build allow and block chains
{% for scope in ['host', 'global'] %}
{% for type, jump in {'block': 'DROP', 'allow': 'ACCEPT'}.items() %}
{% for rule in firewall.rules[scope]['{}6'.format(type)] %}
{% set r = {
  'ip': rule.get('ip', None),
  'proto': rule.get('proto', None),
  'port': rule.get('port', None),
  'delete': rule.get('delete', False)
} %}
iptables6_{{ scope }}_{{ type }}_ip-{{ r.ip }}_proto-{{ r.proto }}_port-{{ r.port }}:
  {% if r.delete %}
  iptables.delete:
  {% else %}
  iptables.append:
  {% endif %}
    - family: ipv6
    - chain: salt-{{ type }}-{{ scope }}
    {% if r.ip %}
    - source: {{ r.ip }}
    {% endif %}
    {% if r.proto %}
    - proto: {{ r.proto }}
    {% endif %}
    {% if r.port %}
    - dport: {{ r.port }}
    {% endif %}
    - jump: {{ jump }}
    - save: True
    - require:
      - iptables: iptables6_{{ type }}-{{ scope }}_chain
{% endfor %}
{% endfor %}
{% endfor %}

{% else %} # firewall disabled

iptables_no_base_rule:
  iptables.delete:
    - family: ipv6
    - chain: INPUT
    - jump: salt-base
    - save: True
    - require:
      - iptables: iptables_base_chain

{% endif %}

iptables6_strict:
  iptables.set_policy:
    - family: ipv6
    - chain: INPUT
    {% if firewall.strict %}
    - policy: DROP
    {% else %}
    - policy: ACCEPT
    {% endif %}
    - require:
      - iptables: iptables6_ping
