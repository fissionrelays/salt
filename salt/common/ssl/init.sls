{% set certs = [salt['grains.get']('id'), 'localhost'] %}

/etc/ssl/salt:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/etc/ssl/salt/openssl.cnf:
  file.managed:
    - user: root
    - group: root
    - mode: 0644
    - source: salt://common/ssl/files/openssl.cnf
    - require:
      - file: /etc/ssl/salt

{% for cert in certs %}
ssl_{{ cert }}_csr:
  cmd.run:
    - name: "openssl req -new -newkey rsa:4096 -nodes -config openssl.cnf -subj '/CN={{ cert }}' -outform pem -out {{ cert }}.csr -keyout {{ cert }}.key"
    - cwd: /etc/ssl/salt
    - unless: ls /etc/ssl/salt/{{ cert }}.key
    - require:
      - file: /etc/ssl/salt/openssl.cnf

ssl_{{ cert }}_key_permissions:
  file.managed:
    - name: /etc/ssl/salt/{{ cert }}.key
    - user: root
    - group: root
    - mode: 640
    - replace: False
    - require:
      - cmd: ssl_{{ cert }}_csr

ssl_{{ cert }}_crt:
  cmd.run:
    - name: "openssl x509 -req -days 7305 -in {{ cert }}.csr -signkey {{ cert }}.key -out {{ cert }}.crt -outform pem -extensions v3_req -extfile openssl.cnf"
    - cwd: /etc/ssl/salt
    - unless: ls /etc/ssl/salt/{{ cert }}.crt
    - require:
      - cmd: ssl_{{ cert }}_csr

ssl_{{ cert }}_delete_csr:
  file.absent:
    - name: /etc/ssl/salt/{{ cert }}.csr
    - require:
      - cmd: ssl_{{ cert }}_crt
{% endfor %}
