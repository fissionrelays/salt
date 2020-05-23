{% for file in ['.alias', '.bashrc', '.selected_editor', '.tmux.conf'] %}

/root/{{ file }}:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - source: salt://files/root/{{ file }}
    - template: jinja

{% endfor %}
