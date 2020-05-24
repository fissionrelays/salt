{% set version = salt['pillar.get']('php:version') %}

/etc/php/{{ version }}/cli/conf.d/60-salt.ini:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://roles/php/files/60-salt.ini
    - template: jinja
    - defaults:
        php: {{ salt['pillar.get']('php') }}
    - require:
      - pkg: install_php
