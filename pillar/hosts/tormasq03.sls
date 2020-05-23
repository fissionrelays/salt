roles:
  - tor

tor:
  SocksPort: 9050
  relay:
    enabled: True
    Nickname: FissionMasq03
    ExitRelay: True
    ORPort: 5753
    DirPort: 6068
