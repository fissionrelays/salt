set_timezone:
  timezone.system:
    - name: {{ salt['pillar.get']('config:timezone') }}

install_locale:
  locale.present:
    - name: {{ salt['pillar.get']('config:locale') }}

set_locale:
  locale.system:
    - name: {{ salt['pillar.get']('config:locale') }}
    - require:
      - locale: install_locale
