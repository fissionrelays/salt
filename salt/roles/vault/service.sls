{% from 'roles/vault/map.jinja' import vault with context %}

/etc/supervisor/conf.d/vault.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://roles/vault/files/vault.conf
    - template: jinja
    - require:
      - file: vault_install
      - file: vault_config

vault_supervisord_reread:
  module.wait:
    - supervisord.reread: []
    - watch:
      - file: /etc/supervisor/conf.d/vault.conf

vault_supervisord_update:
  module.wait:
    - supervisord.update: []
    - watch:
      - module: vault_supervisord_reread

vault_supervisord_restart:
  module.wait:
    - supervisord.restart:
      - name: vault
    - watch:
      - file: vault_config
