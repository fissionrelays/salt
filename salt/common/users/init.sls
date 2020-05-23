{% from './map.jinja' import active_users, revoked_users, sudoers with context %}
{% set authentication = salt['pillar.get']('ssh:authentication', 'keyorpassword') %}

{% for username in revoked_users %}
delete_user_{{ username }}:
  user.absent:
    - name: {{ username }}
    - purge: True
    - force: True
  group.absent:
    - name: {{ username }}
  file.absent:
    - names:
      - /etc/ssh/authorized_keys/{{ username }}
      - /etc/ssh/totp_keys/{{ username }}
{% endfor %}

{% for username in active_users %}
{% set user = salt['vault'].read_secret('secret/data/users/{}'.format(username), 'data') %}
add_user_{{ username }}:
  group.present:
    - name: {{ username }}
    - gid: {{ user.uid }}
  user.present:
    - name: {{ username }}
    - uid: {{ user.uid }}
    - gid: {{ user.uid }}
    - shell: {{ user.get('shell', '/bin/bash') }}
    - home: {{ user.get('home', '/home/{}'.format(username)) }}
    - fullname: {{ user.get('name', '') }}
    - password: {{ user.get('password', '') }}
    {% if username in sudoers %}
    - groups:
      - sudo
    {% endif %}
    {% if user.get('groups', False) %}
    - optional_groups:
      {% for group in user.get('groups').split(',') %}
      - {{ group }}
      {% endfor %}
    {% endif %}

/etc/ssh/authorized_keys/{{ username }}:
{% if user.get('authorized_keys', False) %}
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents:
      - "# Managed by SaltStack"
      - "# {{ user.name }}"
      {% for line in user.authorized_keys.split('\n') %}
      - {{ line }}
      {% endfor %}
    - require:
      - user: add_user_{{ username }}
      - file: /etc/ssh/authorized_keys
{% else %}
  file.absent: []
{% endif %}

/etc/ssh/totp_keys/{{ username }}:
{% if authentication in ['keyandverification', 'passwordandverification', 'keyandpasswordandverification'] and user.get('totp_secret', False) %}
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - contents:
      - {{ user.totp_secret }}
      - "\" DISALLOW_REUSE"
      - "\" RATE_LIMIT 3 300"
      - "\" TOTP_AUTH"
    - require:
      - user: add_user_{{ username }}
      - file: /etc/ssh/totp_keys
{% else %}
  file.absent: []
{% endif %}

{% endfor %}

/etc/sudoers.d/10-sudo-nopasswd:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - source: salt://common/users/files/10-sudo-nopasswd
