roles:
  - apache
  - php
  - tor

apache:
  identity:
    ServerName: web1.fissionrelays.net
    ServerAdmin: admin@fissionrelays.net
  letsencrypt:
    enabled: True
  sites:
    fissionrelays.net:
      aliases:
        - www.fissionrelays.net
      ssl: required
      hsts: True
      certbot: True
      headers:
        Onion-Location: "http://lwpajcgg7w7dckuswg3wco2echkieugjxnn2oomlmdv3tj7tc6bu5mid.onion/"
    lists.fissionrelays.net:
      ssl: required
      hsts: True
      certbot: True
      document_root: /srv/www/lists.fissionrelays.net/public
      headers:
        Onion-Location: "http://q4uj6kprvl4xdap7dkvuybqufzmf4xf77n63jlsxsxlin5zeejjuxlid.onion%{REQUEST_URI}s"
    web1.fissionrelays.net:
      ssl: required
      hsts: True
      certbot: True

tor:
  hiddenservices:
    - dir: /var/lib/tor/fissionrelays_web
      version: 3
      ports:
        - port: 80
          dest: 127.0.0.1:80
    - dir: /var/lib/tor/lists_web
      version: 3
      ports:
        - port: 80
          dest: 127.0.0.1:80
