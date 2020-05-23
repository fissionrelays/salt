roles:
  - tor

firewall:
  strict: False
  rules:
    host:
      allow4:
        - port: 22
          proto: tcp
      allow6:
        - port: 22
          proto: tcp

tor:
  relay:
    enabled: True
    Nickname: FissionEx3
    ORPort6:
      Advertise:
        Address: '[2a01:4f8:1c1c:6cde::1]'
        Port: 443
      Listen:
        Address: '[2a01:4f8:1c1c:6cde::1]'
        Port: 9001
