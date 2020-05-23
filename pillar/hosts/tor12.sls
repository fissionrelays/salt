roles:
  - tor

tor:
  relay:
    enabled: True
    Nickname: Fission12
    ORPort6:
      Advertise:
        Address: '[2001:470:73f7::7]'
        Port: 443
      Listen:
        Address: '[2001:470:73f7::7]'
        Port: 9001
