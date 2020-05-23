roles:
  - tor

tor:
  relay:
    enabled: True
    Nickname: Fission06
    ORPort6:
      Advertise:
        Address: '[2001:470:c91a::5]'
        Port: 443
      Listen:
        Address: '[2001:470:c91a::5]'
        Port: 9001
