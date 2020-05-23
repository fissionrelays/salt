{% if salt['file.file_exists']("/srv/salt/pillar/hosts/{}.sls".format(grains.id)) %}

{% import_yaml "hosts/" + grains.id + ".sls" as host_config %}
{% if host_config.roles is defined and host_config.roles|length > 0 %}

include:
{% for role in host_config.roles %}
  - roles.{{ role }}
{% endfor %}

{% endif %}

{% endif %}
