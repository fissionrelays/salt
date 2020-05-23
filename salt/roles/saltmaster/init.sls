install_salt_master:
  pkg.installed:
    - name: salt-master

add_group_salt:
  group.present:
    - name: salt
    - gid: 3001

/srv/salt:
  file.directory:
    - user: root
    - group: salt
    - mode: 2770

/etc/cron.d/saltmaster:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://roles/saltmaster/files/saltmaster.cron
    - require:
      - group: add_group_salt
