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
    Nickname: FissionEx2
    ExitRelay: True
    ORPort6:
      Advertise:
        Address: '[2607:5300:201:3100::34b0]'
        Port: 443
      Listen:
        Address: '[2607:5300:201:3100::34b0]'
        Port: 9001
