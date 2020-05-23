highstate_schedule:
  schedule.present:
    - function: state.highstate
    - enabled: {{ salt['pillar.get']('salt:auto_highstate') }}
    - seconds: 21600
    - splay: 3600

mine.update:
  module.wait: []

/etc/salt/minion.d/module.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://common/salt/files/module.conf
