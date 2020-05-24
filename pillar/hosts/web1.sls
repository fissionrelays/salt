roles:
  - apache
  - php

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
    lists.fissionrelays.net:
      ssl: required
      hsts: True
      certbot: True
      document_root: /srv/www/lists.fissionrelays.net/public
    web1.fissionrelays.net:
      ssl: required
      hsts: True
      certbot: True
