{% set version = salt['pillar.get']('php:version') %}

php_repo:
  pkgrepo.managed:
    - humanname: PHP
    - name: deb http://ppa.launchpad.net/ondrej/php/ubuntu {{ grains.get('oscodename') }} main
    - dist: {{ grains.get('oscodename') }}
    - file: /etc/apt/sources.list.d/php.list
    - keyid: 4F4EA0AAE5267A6C
    - keyserver: keys.gnupg.net
    - refresh_db: True

install_php:
  pkg.installed:
    - pkgs:
      - php{{ version }}
      {% for extension in salt['pillar.get']('php:extensions', []) %}
      - php{{ version }}-{{ extension }}
      {% endfor %}
      - php-pear
      - composer
    - require:
      - pkgrepo: php_repo

/etc/alternatives/php:
  file.symlink:
    - target: /usr/bin/php{{ version }}
    - require:
      - pkg: install_php
