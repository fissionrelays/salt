{% set firewall = salt['pillar.get']('firewall', {}) %}
{% set strict  = firewall.get('tor', {}).get('strict', True) %}

{% for v in ['4', '6'] %}
iptables{{ v }}_tor_chain:
  iptables.chain_present:
    - name: salt-role-tor
    - family: ipv{{ v }}
    - require:
      - pkg: install_base_packages

iptables{{ v }}_nat_tor_chain:
  iptables.chain_present:
    - name: salt-role-tor
    - family: ipv{{ v }}
    - table: nat
    - require:
      - pkg: install_base_packages

{% if firewall.enabled and (salt['pillar.get']('tor:relay:enabled', False) or salt['pillar.get']('tor:bridge:enabled', False)) %}
iptables{{ v }}_base_tor_rule:
  iptables.append:
    - family: ipv{{ v }}
    - chain: salt-roles
    - jump: salt-role-tor
    - save: True
    - require:
      - iptables: iptables{{ v }}_tor_chain

iptables{{ v }}_nat_base_tor_rule:
  iptables.append:
    - family: ipv{{ v }}
    - table: nat
    - chain: PREROUTING
    - jump: salt-role-tor
    - proto: tcp
    - save: True
    - require:
      - iptables{{ v }}_nat_tor_chain
{% else %}
iptables{{ v }}_base_tor_rule:
  iptables.delete:
    - family: ipv{{ v }}
    - chain: salt-roles
    - jump: salt-role-tor
    - save: True
    - require:
      - iptables: iptables{{ v }}_tor_chain

iptables{{ v }}_nat_base_tor_rule:
  iptables.delete:
    - family: ipv{{ v }}
    - table: nat
    - chain: PREROUTING
    - jump: salt-role-tor
    - proto: tcp
    - save: True
    - require:
      - iptables{{ v }}_nat_tor_chain
{% endif %}
{% endfor %}

{% if firewall.enabled and salt['pillar.get']('tor:relay:enabled', False) %}
{% if salt['pillar.get']('tor:relay:ORPort', None) is mapping %}
iptables4_tor_orport_rule:
  iptables.append:
    - family: ipv4
    - chain: salt-role-tor
    - proto: tcp
    - dport: {{ salt['pillar.get']('tor:relay:ORPort:Listen') }}
    - jump: ACCEPT
    - save: True
    - require:
      - iptables: iptables4_tor_chain

iptables4_nat_tor_orport_rule:
  iptables.append:
    - family: ipv4
    - table: nat
    - chain: salt-role-tor
    - proto: tcp
    - dport: {{ salt['pillar.get']('tor:relay:ORPort:Advertise') }}
    - to-port: {{ salt['pillar.get']('tor:relay:ORPort:Listen') }}
    - jump: REDIRECT
    - save: True
    - require:
      - iptables: iptables4_nat_tor_chain
{% else %}
iptables4_tor_orport_rule:
  iptables.append:
    - family: ipv4
    - chain: salt-role-tor
    - proto: tcp
    - dport: {{ salt['pillar.get']('tor:relay:ORPort') }}
    - jump: ACCEPT
    - save: True
    - require:
      - iptables: iptables4_tor_chain
{% endif %}

{% if salt['pillar.get']('tor:relay:ORPort6') %}
{% if salt['pillar.get']('tor:relay:ORPort6') is mapping %}
iptables6_tor_orport_rule:
  iptables.append:
    - family: ipv6
    - chain: salt-role-tor
    - proto: tcp
    - dport: {{ salt['pillar.get']('tor:relay:ORPort6:Listen:Port') }}
    - jump: ACCEPT
    - save: True
    - require:
      - iptables: iptables6_tor_chain

iptables6_nat_tor_orport_rule:
  iptables.append:
    - family: ipv6
    - table: nat
    - chain: salt-role-tor
    - proto: tcp
    - dport: {{ salt['pillar.get']('tor:relay:ORPort6:Advertise:Port') }}
    - to-port: {{ salt['pillar.get']('tor:relay:ORPort6:Listen:Port') }}
    - jump: REDIRECT
    - save: True
    - require:
      - iptables: iptables6_nat_tor_chain

{% elif salt['pillar.get']('tor:relay:ORPort6') is string %}
iptables6_tor_orport_rule:
  iptables.append:
    - family: ipv6
    - chain: salt-role-tor
    - proto: tcp
    - dport: {{ salt['pillar.get']('tor:relay:ORPort6') }}
    - jump: ACCEPT
    - save: True
    - require:
      - iptables: iptables6_tor_chain
{% endif %}
{% endif %}

{% if salt['pillar.get']('tor:relay:DirPort', None) is mapping %}
iptables4_tor_dirport_rule:
  iptables.append:
    - family: ipv4
    - chain: salt-role-tor
    - proto: tcp
    - dport: {{ salt['pillar.get']('tor:relay:DirPort:Listen') }}
    - jump: ACCEPT
    - save: True
    - require:
      - iptables: iptables4_tor_chain

iptables4_nat_tor_dirport_rule:
  iptables.append:
    - family: ipv4
    - table: nat
    - chain: salt-role-tor
    - proto: tcp
    - dport: {{ salt['pillar.get']('tor:relay:DirPort:Advertise') }}
    - to-port: {{ salt['pillar.get']('tor:relay:DirPort:Listen') }}
    - jump: REDIRECT
    - save: True
    - require:
      - iptables: iptables4_nat_tor_chain
{% else %}
iptables4_tor_dirport_rule:
  iptables.append:
    - family: ipv4
    - chain: salt-role-tor
    - proto: tcp
    - dport: {{ salt['pillar.get']('tor:relay:DirPort') }}
    - jump: ACCEPT
    - save: True
    - require:
      - iptables: iptables4_tor_chain
{% endif %}
{% endif %}

{% if firewall.enabled and salt['pillar.get']('tor:bridge:enabled', False) %}
{% for v in ['4', '6'] %}

iptables{{ v }}_tor_bridge_orport:
  iptables.append:
    - family: ipv{{ v }}
    - chain: salt-role-tor
    - proto: tcp
    - dport: {{ salt['pillar.get']('tor:bridge:ORPort') }}
    - jump: ACCEPT
    - save: True
    - require:
      - iptables: iptables{{ v }}_tor_chain

iptables{{ v }}_tor_bridge_obfs:
  iptables.append:
    - family: ipv{{ v }}
    - chain: salt-role-tor
    - proto: tcp
    - dport: {{ salt['pillar.get']('tor:bridge:ServerTransportListenPort') }}
    - jump: ACCEPT
    - save: True
    - require:
      - iptables: iptables{{ v }}_tor_chain

{% for port in salt['pillar.get']('tor:bridge:alt_ports', []) %}
iptables{{ v }}_tor_bridge_port_{{ port }}:
  iptables.append:
    - family: ipv{{ v }}
    - chain: salt-role-tor
    - proto: tcp
    - dport: {{ port }}
    - jump: ACCEPT
    - save: True
    - require:
      - iptables: iptables{{ v }}_tor_chain

{% if port != salt['pillar.get']('tor:bridge:ServerTransportListenPort') %}
iptables{{ v }}_nat_tor_bridge_port_{{ port }}:
  iptables.append:
    - family: ipv{{ v }}
    - table: nat
    - chain: salt-role-tor
    - proto: tcp
    - dport: {{ port }}
    - to-port: {{ salt['pillar.get']('tor:bridge:ServerTransportListenPort') }}
    - jump: REDIRECT
    - save: True
    - require:
      - iptables: iptables{{ v }}_nat_tor_chain
{% endif %}
{% endfor %}
{% endfor %}
{% endif %}
