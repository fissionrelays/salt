apache2:
  pkg.installed: []

/etc/apache2/mods-enabled/headers.load:
  file.symlink:
    - target: ../mods-available/headers.load
    - require:
      - pkg: apache2
    - watch_in:
      - module: restart_apache_setup

/etc/apache2/mods-enabled/proxy_http.load:
  file.symlink:
    - target: ../mods-available/proxy_http.load
    - require:
      - pkg: apache2
    - watch_in:
      - module: restart_apache_setup

/etc/apache2/mods-enabled/proxy.conf:
  file.symlink:
    - target: ../mods-available/proxy.conf
    - require:
      - pkg: apache2
    - watch_in:
      - module: restart_apache_setup

/etc/apache2/mods-enabled/proxy.load:
  file.symlink:
    - target: ../mods-available/proxy.load
    - require:
      - pkg: apache2
      - file: /etc/apache2/mods-enabled/proxy_http.load
      - file: /etc/apache2/mods-enabled/proxy.conf
    - watch_in:
      - module: restart_apache_setup

/etc/apache2/mods-enabled/socache_shmcb.load:
  file.symlink:
    - target: ../mods-available/socache_shmcb.load
    - require:
      - pkg: apache2
    - watch_in:
      - module: restart_apache_setup

/etc/apache2/mods-enabled/ssl.conf:
  file.symlink:
    - target: ../mods-available/ssl.conf
    - require:
      - pkg: apache2
    - watch_in:
      - module: restart_apache_setup

/etc/apache2/mods-enabled/ssl.load:
  file.symlink:
    - target: ../mods-available/ssl.load
    - require:
      - pkg: apache2
      - file: /etc/apache2/mods-enabled/socache_shmcb.load
      - file: /etc/apache2/mods-enabled/ssl.conf
    - watch_in:
      - module: restart_apache_setup

/etc/apache2/mods-enabled/rewrite.load:
  file.symlink:
    - target: ../mods-available/rewrite.load
    - require:
      - pkg: apache2
    - watch_in:
      - module: restart_apache_setup

/srv/www:
  file.directory:
    - user: root
    - group: root
    - mode: 0755
    - makedirs: True
