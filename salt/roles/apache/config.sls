/etc/apache2/apache2.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 0644
    - source: salt://roles/apache/files/apache2.conf
    - require:
      - pkg: apache2
    - watch_in:
      - module: restart_apache_setup

/etc/apache2/ports.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 0644
    - source: salt://roles/apache/files/ports.conf
    - require:
      - pkg: apache2
    - watch_in:
      - module: restart_apache_setup

/etc/apache2/conf-available/acme.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 0644
    - source: salt://roles/apache/files/acme.conf
    - template: jinja
    - require:
      - pkg: apache2
    - watch_in:
      - module: restart_apache_setup

/etc/apache2/conf-enabled/acme.conf:
  file.symlink:
    - target: ../conf-available/acme.conf
    - require:
      - file: /etc/apache2/conf-available/acme.conf
    - watch_in:
      - module: restart_apache_setup

/etc/apache2/conf-available/identity.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 0644
    - source: salt://roles/apache/files/identity.conf
    - template: jinja
    - require:
      - pkg: apache2
    - watch_in:
      - module: restart_apache_setup

/etc/apache2/conf-enabled/identity.conf:
  file.symlink:
    - target: ../conf-available/identity.conf
    - require:
      - file: /etc/apache2/conf-available/identity.conf
    - watch_in:
      - module: restart_apache_setup

/etc/apache2/conf-available/security.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 0644
    - source: salt://roles/apache/files/security.conf
    - require:
      - pkg: apache2
    - watch_in:
      - module: restart_apache_setup

/etc/apache2/conf-enabled/security.conf:
  file.symlink:
    - target: ../conf-available/security.conf
    - require:
      - file: /etc/apache2/conf-available/security.conf
    - watch_in:
      - module: restart_apache_setup

/etc/apache2/sites-available/000-default.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 0644
    - source: salt://roles/apache/files/000-default.conf
    - require:
      - pkg: apache2
      - file: /etc/apache2/mods-enabled/headers.load
      - file: /etc/apache2/mods-enabled/proxy.load
      - file: /etc/apache2/mods-enabled/ssl.load
      - file: /etc/apache2/mods-enabled/rewrite.load
    - watch_in:
      - module: restart_apache_setup

/etc/apache2/sites-enabled/000-default.conf:
  file.symlink:
    - target: ../sites-available/000-default.conf
    - require:
      - file: /etc/apache2/sites-available/000-default.conf
    - watch_in:
      - module: restart_apache_setup
