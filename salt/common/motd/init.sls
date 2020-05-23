/etc/update-motd.d/10-help-text:
  file.absent: []

/etc/update-motd.d/80-livepatch:
  file.absent: []

/etc/default/motd-news:
  file.managed:
    - user: root
    - group: root
    - mode: 755
    - source: salt://common/motd/files/motd-news

update-motd:
  cmd.wait:
    - require:
      - pkg: install_base_packages
    - watch:
      - file: /etc/update-motd.d/10-help-text
      - file: /etc/update-motd.d/80-livepatch
      - file: /etc/default/motd-news
