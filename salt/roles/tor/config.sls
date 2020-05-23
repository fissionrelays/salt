/etc/tor/tor-exit-notice.html:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://roles/tor/files/tor-exit-notice.html
    - template: jinja
    - require:
      - pkg: install_tor
    - watch_in:
      - service: tor_service

/etc/tor/torrc:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://roles/tor/files/torrc
    - template: jinja
    - require:
      - pkg: install_tor
      - file: /etc/tor/tor-exit-notice.html
    - watch_in:
      - service: tor_service

{% if salt['pillar.get']('tor:bridge:enabled', False) %}
/etc/systemd/system/tor@default.service.d/allow-new-priv.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - source: salt://roles/tor/files/allow-new-priv.conf
    - require:
      - pkg: install_tor

tor_setcap:
  cmd.wait:
    - name: "setcap cap_net_bind_service=+ep /usr/bin/obfs4proxy"
    - watch:
      - pkg: install_tor
      - file: /etc/systemd/system/tor@default.service.d/allow-new-priv.conf

tor_systemd_reload:
  module.wait:
    - service.systemctl_reload:
    - watch:
      - cmd: tor_setcap
    - watch_in:
      - service: tor_service
{% endif %}
