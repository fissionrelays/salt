/usr/local/sbin/reboot-if-required:
  file.managed:
    - user: root
    - group: root
    - mode: 755
    - source: salt://common/reboot/files/reboot-if-required

/etc/cron.d/reboot-if-required:
  {% if salt['pillar.get']('salt:auto_reboot') %}
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://common/reboot/files/reboot-if-required
  {% else %}
  file.absent: []
  {% endif %}
