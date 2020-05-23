config:
  locale: en_US.UTF-8
  timezone: America/Chicago

firewall:
  enabled: True
  strict: False
  ping: True
  rules:
    global:
      allow4:
        - ip: 10.12.10.0/24
          proto: tcp
          port: 22
      block4: []
      allow6:
        - ip: "2001:470:b91f:a00::/64"
          proto: tcp
          port: 22
      block6: []
    host:
      allow4: []
      block4: []
      allow6: []
      block6: []

networking:
  datacenter: fission
  domainname: fissionrelays.net

salt:
  auto_highstate: True
  auto_reboot: False

ssh:
  authentication: key
  port: 22

users:
  common:
    active:
      - kevin
    revoked:
      - oob
