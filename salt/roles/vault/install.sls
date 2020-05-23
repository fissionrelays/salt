{% from 'roles/vault/map.jinja' import vault with context %}

add_user_vault:
  group.present:
    - name: {{ vault.group }}
    - gid: {{ vault.gid }}
  user.present:
    - name: {{ vault.user }}
    - uid: {{ vault.uid }}
    - groups:
      - vault
    - home: /home/{{ vault.user }}
    - createhome: True
    - system: True
    - require:
      - group: add_user_vault

vault_dir_base:
  file.directory:
    - name: {{ vault.base_dir }}
    - makedirs: True
    - user: {{ vault.user }}
    - group: {{ vault.group }}
    - mode: 755
    - require:
      - user: add_user_vault

vault_dir_bin:
  file.directory:
    - name: {{ vault.base_dir }}/bin
    - user: {{ vault.user }}
    - group: {{ vault.group }}
    - mode: 755
    - require:
      - file: vault_dir_base

vault_dir_config:
  file.directory:
    - name: {{ vault.base_dir }}/config
    - user: {{ vault.user }}
    - group: {{ vault.group }}
    - mode: 750
    - require:
      - file: vault_dir_base

vault_dir_data:
  file.directory:
    - name: {{ vault.base_dir }}/data
    - user: {{ vault.user }}
    - group: {{ vault.group }}
    - mode: 750
    - require:
      - file: vault_dir_base

vault_dir_log:
  file.directory:
    - name: {{ vault.base_dir }}/log
    - user: {{ vault.user }}
    - group: {{ vault.group }}
    - mode: 750
    - require:
      - file: vault_dir_base

vault_dir_tls:
  file.directory:
    - name: {{ vault.base_dir }}/tls
    - user: {{ vault.user }}
    - group: {{ vault.group }}
    - mode: 750
    - require:
      - file: vault_dir_base

vault_download:
  file.managed:
    - name: /tmp/vault_{{ vault.version }}_linux_{{ vault.arch }}.zip
    - source: https://{{ vault.download_host }}/vault/{{ vault.version }}/vault_{{ vault.version }}_linux_{{ vault.arch }}.zip
    - source_hash: https://{{ vault.download_host }}/vault/{{ vault.version }}/vault_{{ vault.version }}_SHA256SUMS
    - unless: test -f {{ vault.base_dir }}/bin/vault-{{ vault.version }}

vault_extract:
  cmd.wait:
    - name: unzip /tmp/vault_{{ vault.version }}_linux_{{ vault.arch }}.zip -d /tmp
    - require:
      - pkg: install_base_packages
    - watch:
      - file: vault_download

vault_install:
  file.rename:
    - name: {{ vault.base_dir }}/bin/vault-{{ vault.version }}
    - source: /tmp/vault
    - require:
      - file: vault_dir_bin
    - watch:
      - cmd: vault_extract

vault_clean:
  file.absent:
    - name: /tmp/vault_{{ vault.version }}_linux_{{ vault.arch }}.zip
    - require:
      - file: vault_install

vault_link:
  file.symlink:
    - name: /usr/local/bin/vault
    - target: {{ vault.base_dir }}/bin/vault-{{ vault.version }}
    - require:
      - file: vault_install

vault_setcap:
  cmd.wait:
    - name: "setcap cap_ipc_lock=+ep $(readlink -f $(which vault))"
    - watch:
      - file: vault_link
