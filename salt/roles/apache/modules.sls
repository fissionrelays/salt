restart_apache:
  module.wait:
    - service.restart:
      - name: apache2
    - require:
      - pkg: apache2

restart_apache_setup:
  module.wait:
    - service.restart:
      - name: apache2
    - require:
      - pkg: apache2

reload_apache:
  module.wait:
    - service.reload:
      - name: apache2
    - require:
      - pkg: apache2
