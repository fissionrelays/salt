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
    Nickname: FissionEx1
    ExitRelay: False # Not allowed on OVH US
    ORPort6:
      Advertise:
        Address: '[2604:2dc0:101:100::a7]'
        Port: 443
      Listen:
        Address: '[2604:2dc0:101:100::a7]'
        Port: 9001
