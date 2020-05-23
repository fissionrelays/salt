expand_ubuntu_lv:
  cmd.run:
    - name: "lvextend -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv"
    - unless: test -f /root/.lvextend

resize_ubuntu_lv:
  cmd.run:
    - name: "resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv"
    - onchanges:
      - cmd: expand_ubuntu_lv


/root/.lvextend:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - onchanges:
      - cmd: resize_ubuntu_lv
