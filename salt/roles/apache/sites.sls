{% set letsencrypt = salt['pillar.get']('apache:letsencrypt:enabled', False) %}

{% for site_id, site_data in salt['pillar.get']('apache:sites', {}).items() %}
{% set site = {
  'id': site_id,
  'enabled': site_data.get('enabled', True),
  'type': site_data.get('type', 'site'),
  'aliases': site_data.get('aliases', []),
  'ssl': site_data.get('ssl', 'disabled'),
  'certbot': site_data.get('certbot', False),
  'hsts': site_data.get('hsts', False),
  'headers': site_data.get('headers', {}),
  'ssl_certificate': site_data.get('ssl_certificate', ''),
  'ssl_certificate_chain': site_data.get('ssl_certificate_chain', ''),
  'ssl_private_key': site_data.get('ssl_private_key', ''),
  'document_root': site_data.get('document_root', '/srv/www/{}'.format(site_id)),
  'proxy_dest': site_data.get('proxy_dest', ''),
  'target': site_data.get('target', '')
} %}

{% if site['type'] in ['site', 'redirect', 'proxy'] %}
/etc/apache2/sites-available/{{ site['id'] }}.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 0644
    - source: salt://roles/apache/files/{{ site['type'] }}.conf
    - template: jinja
    - context:
        site: {{ site|json }}
    - require:
      - pkg: apache2
      {% if site['ssl'] in ['required', 'optional'] %}
      {% if letsencrypt and site['certbot'] %}
      - file: letsencrypt_symlink_{{ site['id'] }}
      {% else %}
      - file: /etc/ssl/certs/{{ site_id }}/cert.pem
      - file: /etc/ssl/certs/{{ site_id }}/chain.pem
      - file: /etc/ssl/certs/{{ site_id }}/privkey.pem
      {% endif %}
      {% endif %}
    - watch_in:
      - module: reload_apache

/etc/apache2/sites-enabled/{{ site['id']}}.conf:
  {% if site['enabled'] %}
  file.symlink:
    - target: ../sites-available/{{ site['id'] }}.conf
  {% else %}
  file.absent:
  {% endif %}
    - require:
      - file: /etc/apache2/sites-available/{{ site['id'] }}.conf
    - watch_in:
      - reload_apache

{% endif %}

{% if site['type'] == 'site' %}
/srv/www/{{ site['id'] }}:
  file.directory:
    - user: www-data
    - group: www-data
    - mode: 0775
    - require:
      - pkg: apache2
      - file: /srv/www
{% endif %}
{% endfor %}
