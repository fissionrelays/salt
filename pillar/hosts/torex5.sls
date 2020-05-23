roles:
  - tor

firewall:
  rules:
    host:
      allow4:
        - port: 22
          proto: tcp

tor:
  SocksPort: 9050
  relay:
    enabled: True
    Nickname: FissionEx5
    ExitRelay: True

users:
  host:
    revoked:
      - blackhost
