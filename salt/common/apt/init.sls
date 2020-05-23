/etc/apt/apt.conf.d/10periodic:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://common/apt/files/10periodic

/etc/apt/apt.conf.d/50unattended-upgrades:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://common/apt/files/50unattended-upgrades

aptget_update:
  module.wait:
    - pkg.refresh_db: []
