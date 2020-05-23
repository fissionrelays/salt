/etc/ssh/sshd_config:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://common/ssh/files/sshd_config
    - template: jinja
    - require:
      - pkg: install_ssh
    - watch_in:
      - service: sshd_service

/etc/motd:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://files/ssh/motd-{{ salt['pillar.get']('networking:datacenter') }}
    - watch_in:
      - service: sshd_service

/etc/pam.d/sshd:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://common/ssh/files/pamd_sshd
    - template: jinja
    - require:
      - pkg: install_ssh
    - watch_in:
      - service: sshd_service

{% set hostname = salt['pillar.get']('networking:hostname', salt['grains.get']('host')) %}
{% set domainname = salt['pillar.get']('networking:domainname') %}
{% set principals = (['{}.{}'.format(hostname,domainname)] + salt['pillar.get']('ssh:principals', [])) | join(',') %}

{% for type in ['ecdsa', 'ed25519', 'rsa'] %}
{% if salt['file.file_exists']('/etc/ssh/ssh_host_{}_key.pub'.format(type)) and not salt['file.file_exists']('/etc/ssh/ssh_host_{}_key-cert.pub'.format(type)) %}
/etc/ssh/ssh_host_{{ type }}_key-cert.pub:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: {{ salt['vault.write_secret']('ssh/sign/host', cert_type='host', valid_principals=principals, public_key=salt['file.read']('/etc/ssh/ssh_host_{}_key.pub'.format(type))).signed_key }}
    - require_in:
      - file: /etc/ssh/sshd_config
    - watch_in:
      - service: sshd_service
{% endif %}
{% endfor %}

/etc/ssh/ssh_known_hosts:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents:
      - "@cert-authority *.{{ domainname }} {{ salt['vault'].read_secret('ssh/config/ca').public_key }}"
