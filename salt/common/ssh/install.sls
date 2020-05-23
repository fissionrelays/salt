install_ssh:
  pkg.installed:
    - pkgs:
      - openssh-server
      - libpam-google-authenticator

sshd_service:
  service.running:
    - name: ssh

/etc/ssh/authorized_keys:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - require:
      - pkg: install_ssh

/etc/ssh/totp_keys:
  file.directory:
    - user: root
    - group: root
    - mode: 700
    - require:
      - pkg: install_ssh
