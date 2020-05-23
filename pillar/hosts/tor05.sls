roles:
  - tor

tor:
  relay:
    enabled: True
    Nickname: Fission05
    ORPort6:
      Advertise:
        Address: '[2001:470:c91a::4]'
        Port: 443
      Listen:
        Address: '[2001:470:c91a::4]'
        Port: 9001
