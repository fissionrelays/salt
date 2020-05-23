{% set hostname = salt['pillar.get']('networking:hostname', salt['grains.get']('host')) %}
{% if hostname != salt['grains.get']('host') %}
hostname_apply:
  cmd.run:
    - name: hostnamectl set-hostname {{ hostname }}
    - require_in:
      - file: /etc/hosts

hostname_sync_grains:
  module.wait:
    - name: saltutil.sync_grains
    - watch:
      - cmd: hostname_apply
    - require_in:
      - file: /etc/hosts
{% endif %}

/etc/hosts:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://common/networking/files/hosts
    - template: jinja
