roles:
  - tor

tor:
  relay:
    enabled: True
    Nickname: Fission10
    ORPort6:
      Advertise:
        Address: '[2001:470:73f7::5]'
        Port: 443
      Listen:
        Address: '[2001:470:73f7::5]'
        Port: 9001
