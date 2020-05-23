tor:
  DataDirectory: /var/lib/tor
  SocksPort: 9050 IPv6Traffic
  ControlPort: 9051
  Log: notice file /var/log/tor/log
  relay:
    enabled: False
    ContactInfo: Kevin Hicks <admin@fissionrelays.net>
    ORPort:
      Advertise: 443
      Listen: 9001
    DirPort:
      Advertise: 80
      Listen: 9030
    DirPortFrontPage: /etc/tor/tor-exit-notice.html
    ExitRelay: False
    ExitPolicy:
      - 'accept *:20-21     # FTP'
      - 'accept *:22        # SSH'
      - 'accept *:23        # Telnet'
      - 'accept *:43        # WHOIS'
      - 'accept *:53        # DNS'
      - 'accept *:79        # finger'
      - 'accept *:80-81     # HTTP'
      - 'accept *:88        # kerberos'
      - 'accept *:110       # POP3'
      - 'accept *:143       # IMAP'
      - 'accept *:194       # IRC'
      - 'accept *:220       # IMAP3'
      - 'accept *:389       # LDAP'
      - 'accept *:443       # HTTPS'
      - 'accept *:464       # kpasswd'
      - 'accept *:465       # URD for SSM (more often: an alternative SUBMISSION port, see 587)'
      - 'accept *:531       # IRC/AIM'
      - 'accept *:543-544   # Kerberos'
      - 'accept *:554       # RTSP'
      - 'accept *:563       # NNTP over SSL'
      - 'accept *:587       # SUBMISSION (authenticated clients [MUAs like Thunderbird] send mail over STARTTLS SMTP here)'
      - 'accept *:636       # LDAP over SSL'
      - 'accept *:706       # SILC'
      - 'accept *:749       # kerberos '
      - 'accept *:853       # DNS over TLS'
      - 'accept *:873       # rsync'
      - 'accept *:902-904   # VMware'
      - 'accept *:981       # Remote HTTPS management for firewall'
      - 'accept *:989-990   # FTP over SSL'
      - 'accept *:991       # Netnews Administration System'
      - 'accept *:992       # TELNETS'
      - 'accept *:993       # IMAP over SSL'
      - 'accept *:994       # IRCS'
      - 'accept *:995       # POP3 over SSL'
      - 'accept *:1194      # OpenVPN'
      - 'accept *:1220      # QT Server Admin'
      - 'accept *:1293      # PKT-KRB-IPSec'
      - 'accept *:1500      # VLSI License Manager'
      - 'accept *:1533      # Sametime'
      - 'accept *:1677      # GroupWise'
      - 'accept *:1723      # PPTP'
      - 'accept *:1755      # RTSP'
      - 'accept *:1863      # MSNP'
      - 'accept *:2082      # Infowave Mobility Server'
      - 'accept *:2083      # Secure Radius Service (radsec)'
      - 'accept *:2086-2087 # GNUnet, ELI'
      - 'accept *:2095-2096 # NBX'
      - 'accept *:2102-2104 # Zephyr'
      - 'accept *:3128      # SQUID'
      - 'accept *:3389      # MS WBT'
      - 'accept *:3690      # SVN'
      - 'accept *:4321      # RWHOIS'
      - 'accept *:4643      # Virtuozzo'
      - 'accept *:5050      # MMCC'
      - 'accept *:5190      # ICQ'
      - 'accept *:5222-5223 # XMPP, XMPP over SSL'
      - 'accept *:5228      # Android Market'
      - 'accept *:5900      # VNC'
      - 'accept *:6660-6669 # IRC'
      - 'accept *:6679      # IRC SSL  '
      - 'accept *:6697      # IRC SSL  '
      - 'accept *:8000      # iRDMI'
      - 'accept *:8008      # HTTP alternate'
      - 'accept *:8074      # Gadu-Gadu'
      - 'accept *:8080      # HTTP Proxies'
      - 'accept *:8082      # HTTPS Electrum Bitcoin port'
      - 'accept *:8087-8088 # Simplify Media SPP Protocol, Radan HTTP'
      - 'accept *:8232-8233 # Zcash'
      - 'accept *:8332-8333 # Bitcoin'
      - 'accept *:8443      # PCsync HTTPS'
      - 'accept *:8888      # HTTP Proxies, NewsEDGE'
      - 'accept *:9418      # git'
      - 'accept *:9999      # distinct'
      - 'accept *:10000     # Network Data Management Protocol'
      - 'accept *:11371     # OpenPGP hkp (http keyserver protocol)'
      - 'accept *:19294     # Google Voice TCP'
      - 'accept *:19638     # Ensim control panel'
      - 'accept *:50002     # Electrum Bitcoin SSL'
      - 'accept *:64738     # Mumble'
    MyFamily:
      - 62712B2C24A169B24336CD2FE2BE55DA67476C8B #tor01
      - 937F201D2797314953F268D252F5C98D3FA9F71E #tor02
      - 4F500157ABF70A1A94636D268A742A8B227B8BFD #tor03
      - 0B841CB70F9ED1FD0322C2BA2EB0D80420D87CFA #tor04
      - 71539D1911ECB826069A4D156771AC4F9F4632A7 #tor05
      - 91E7CA6B8D0AAD77C7CFB8FEA25BF4F46DA1042A #tor06
      - 5D765770B4DB110D88787457978AB4008CF65CAC #tor07
      - 53134D9637D9FBE565FA1E3AF82B23CC964C56D6 #tor08
      - 98138DFD3E2C8C89D8F5AB11EF9B6BFF272D83B4 #tor09
      - 438DC9B6B5C5375D332BB338D7E5C1B9EF448960 #tor10
      - 929BB84A68198CE35E2F2828812840AF5C2CBC4A #tor11
      - C303038FDCC72805A160FF64E994333A49ECDA71 #tor12
      - ECB24A326D382F84B7BD630CFDBE1A0CDCE0245A #torex1
      - 460E5B882770C19761BC5747541913DB2AD01E35 #torex2
      - 4FDDFAD51B24DDABB62FB59071F4DC421E76C685 #torex3
      - 3B4C5729F829CA2E895B81AF834A63DB336D0FFE #torex4
      - DE0421FBD771E6189205D353366874B1790185C7 #torex5
      - 4A411DD8EBBD539AA0090A305856B9C838F7F2D6 #tormasq01
      - 5FA7596FB2BA2C889337F8B82DD7127BBB240D4D #tormasq02
      - 8628D2ACCA1C9BE596DED1DF9D0099BBDB1352B3 #tormasq03
      - 7533ABDA9027F40CF87FB6189AEBB1F43A132A0B #tormasq04
      - 41427448C41642832130C2C29AF1FEAC3B3EED35 #tormasq05
      - 87357FCC2BF2C21F069714381BCA6C3E7EFCBD5D #tormasq06
  bridge:
    enabled: False
    ContactInfo: Kevin Hicks <admin@fissionrelays.net>
    ORPort: 39533
    PublishServerDescriptor: bridge
    ServerTransportPlugin: obfs4 exec /usr/bin/obfs4proxy
    ServerTransportListenPlugin: obfs4
    ServerTransportListenAddr: 0.0.0.0
    ServerTransportListenPort: 443
    ExtORPort: auto
    alt_ports:
      - 53
      - 80
      - 8080
      - 8443
