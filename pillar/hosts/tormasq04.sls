roles:
  - tor

tor:
  SocksPort: 9050
  relay:
    enabled: True
    Nickname: FissionMasq04
    ExitRelay: True
    ORPort: 10750
    DirPort: 20753
