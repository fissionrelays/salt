roles:
  - apache
  - vault

apache:
  identity:
    ServerName: vault.fissionrelays.net
    ServerAdmin: admin@fissionrelays.net
  letsencrypt:
    enabled: True
  sites:
    vault.fissionrelays.net:
      type: proxy
      ssl: required
      hsts: True
      proxy_dest: http://127.0.0.1:8200/
      certbot: True
