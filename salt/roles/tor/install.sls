{% if salt['grains.get']('os') == 'Ubuntu' and salt['grains.get']('osrelease') in ['14.04', '16.04', '18.04'] %}
tor_repo:
  pkgrepo.managed:
    - humanname: Tor
    - name: deb http://deb.torproject.org/torproject.org {{ salt['grains.get']('oscodename') }} main
    - dist: {{ salt['grains.get']('oscodename') }}
    - file: /etc/apt/sources.list.d/tor.list
    - key_url: https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc
    - require:
      - pkg: install_base_packages

refresh_packages:
  module.wait:
    - name: pkg.refresh_db
    - watch:
      - pkgrepo: tor_repo
    - require_in:
      - pkg: install_tor
      - pkg: install_tor_keyring

install_tor_keyring:
  pkg.installed:
    - name: deb.torproject.org-keyring
    - require:
      - pkg: install_base_packages

install_tor:
  pkg.installed:
    - pkgs:
      - tor
      - obfs4proxy
    - require:
      - pkg: install_tor_keyring

{% else %}
install_tor:
  pkg.installed:
    - name: tor
{% endif %}

{% if salt['grains.get']('os') == 'Ubuntu' and salt['grains.get']('osrelease') == '18.04' %}
install_nyx:
  pkg.installed:
    - name: nyx
    - require:
      - pkg: install_tor
{% else %}
install_nyx:
  pip.installed:
    - name: nyx
    - bin_env: /usr/bin/pip3
    - upgrade: True
    - require:
      - pkg: install_tor
{% endif %}

tor_service:
  service.running:
    - name: tor
    - require:
      - pkg: install_tor
