{% from 'roles/vault/map.jinja' import vault with context %}

vault_config:
  file.serialize:
    - name: {{ vault.base_dir }}/config/vault.json
    - formatter: json
    - dataset: {{ vault.config }}
    - user: {{ vault.user }}
    - group: {{ vault.group }}
    - mode: 640
    - require:
      - file: vault_dir_config
      - file: vault_dir_tls
