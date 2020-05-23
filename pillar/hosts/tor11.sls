roles:
  - tor

tor:
  relay:
    enabled: True
    Nickname: Fission11
    ORPort6:
      Advertise:
        Address: '[2001:470:73f7::6]'
        Port: 443
      Listen:
        Address: '[2001:470:73f7::6]'
        Port: 9001
