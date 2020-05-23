vault:
  version: 1.4.1
  download_host: releases.hashicorp.com
  base_dir: /opt/vault

  user: vault
  group: vault
  uid: 820
  gid: 820

  config:
    ui: true
    default_lease_ttl: 2764800s
    max_lease_ttl: 3153600000s
    storage:
      file:
        path: /opt/vault/data
    listener:
      tcp:
        address: "127.0.0.1:8200"
        tls_disable: 1
        x_forwarded_for_authorized_addrs: "127.0.0.1"
