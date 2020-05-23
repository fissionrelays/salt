{% set php_version = salt['pillar.get']('php:version') %}

apache_php_mod:
  pkg.installed:
    - name: libapache2-mod-php{{ php_version }}
    - require:
      - pkg: apache2
      - pkg: install_php
    - watch_in:
      - module: restart_apache

apache_disable_all_php:
  cmd.run:
    - name: "a2dismod php*"
    - onchanges:
      - file: /etc/alternatives/php

apache_enable_php:
  cmd.run:
    - name: a2enmod php{{ php_version }}
    - require:
      - pkg: apache_php_mod
    - onchanges:
      - cmd: apache_disable_all_php
    - watch_in:
      - module: restart_apache

{% for extension in salt['pillar.get']('php:extensions', []) %}
/etc/php/{{ php_version }}/apache2/conf.d/20-{{ extension }}.ini:
  file.symlink:
    - target: /etc/php/{{ php_version }}/mods-available/{{ extension }}.ini
    - require:
      - pkg: apache2
      - pkg: install_php
    - watch_in:
      - module: restart_apache
{% endfor %}

/etc/php/{{ php_version }}/apache2/conf.d/60-apache-php.ini:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://roles/apache/files/60-apache-php.ini
    - template: jinja
    - defaults:
        php: {{ salt['pillar.get']('php') }}
    - require:
      - pkg: apache2
      - pkg: install_php
    - watch_in:
      - restart_apache
