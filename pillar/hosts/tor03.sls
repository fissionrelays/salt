roles:
  - tor

tor:
  relay:
    enabled: True
    Nickname: Fission03
    ORPort6:
      Advertise:
        Address: '[2001:470:b14a::6]'
        Port: 443
      Listen:
        Address: '[2001:470:b14a::6]'
        Port: 9001
