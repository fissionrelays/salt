include:
  - roles.apache.install
  - roles.apache.config
  - roles.apache.letsencrypt
  - roles.apache.sites
  - roles.apache.modules
  {% if 'php' in salt['pillar.get']('roles') %}
  - roles.apache.php
  {% endif %}
