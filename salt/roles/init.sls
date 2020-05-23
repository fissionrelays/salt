{% if salt['pillar.get']('roles', [])|length > 0 %}
include:
  {% for role in salt['pillar.get']('roles') %}
  - roles.{{ role }}
  {% endfor %}
{% endif %}
