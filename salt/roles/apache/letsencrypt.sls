{% if salt['pillar.get']('apache:letsencrypt:enabled', False) %}
certbot_ppa:
  pkgrepo.managed:
    - ppa: certbot/certbot

install_certbot:
  pkg.latest:
    - pkgs:
      - certbot
      - python-certbot-apache
    - refresh: True
    - require:
      - pkg: apache2
      - pkgrepo: certbot_ppa

/srv/www/acme/.well-known:
  file.directory:
    - user: root
    - group: root
    - mode: 0755
    - makedirs: True
    - require:
      - pkg: install_certbot

/etc/letsencrypt/cli.ini:
  file.managed:
    - user: root
    - group: root
    - mode: 0644
    - source: salt://roles/apache/files/cli.ini
    - template: jinja
    - require:
      - pkg: install_certbot
      - file: /srv/www/acme/.well-known

/usr/local/sbin/check_letsencrypt_cert:
  file.managed:
    - user: root
    - group: root
    - mode: 0755
    - source: salt://roles/apache/files/check_letsencrypt_cert
    - require:
      - file: /etc/letsencrypt/cli.ini

/usr/local/sbin/renew_letsencrypt_cert:
  file.managed:
    - user: root
    - group: root
    - mode: 0755
    - source: salt://roles/apache/files/renew_letsencrypt_cert
    - require:
      - file: /usr/local/sbin/check_letsencrypt_cert

{% for site_id, site_data in salt['pillar.get']('apache:sites', {}).items() %}
{% set site = {
    'id': site_id,
    'ssl': site_data.get('ssl', 'disabled'),
    'aliases': site_data.get('aliases', []),
    'certbot': site_data.get('certbot', False)
} %}

{% if site['certbot'] and site['ssl'] in ['optional', 'required'] %}
letsencrypt_create_{{ site['id'] }}:
  cmd.run:
    - name: /usr/local/sbin/renew_letsencrypt_cert {{ site['id'] }} {{ site['aliases']|join(' ') }}
    - unless: /usr/local/sbin/check_letsencrypt_cert {{ site['id'] }} {{ site['aliases']|join(' ') }}
    - require:
      - file: /usr/local/sbin/renew_letsencrypt_cert
      - file: /etc/apache2/apache2.conf
      - file: /etc/apache2/sites-enabled/000-default.conf

letsencrypt_symlink_{{ site['id'] }}:
  file.symlink:
    - name: /etc/ssl/certs/{{ site['id'] }}
    - target: /etc/letsencrypt/live/{{ site['id'] }}
    - require:
      - cmd: letsencrypt_create_{{ site['id'] }}
{% endif %}
{% endfor %}

{% for cert_list in salt['pillar.get']('apache:letsencrypt:certificates', []) %}
letsencrypt_create_{{ cert_list[0] }}:
  cmd.run:
    - name: /usr/local/sbin/renew_letsencrypt_cert {{ cert_list|join(' ') }}
    - unless: /usr/local/sbin/check_letsencrypt_cert {{ cert_list|join(' ') }}
    - require:
      - file: /usr/local/sbin/renew_letsencrypt_cert
      - file: /etc/apache2/apache2.conf
      - file: /etc/apache2/conf-enabled/acme.conf
      - file: /etc/apache2/sites-enabled/000-default.conf
{% endfor %}

{% endif %}
