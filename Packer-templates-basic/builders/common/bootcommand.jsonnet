      [
        "<esc><esc><enter><wait>",
        "/install/vmlinuz noapic ",
        "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg <wait>",
        "debian-installer=en_US auto locale=en_US kbd-chooser/method=us <wait>",
        "hostname={{user `hostname`}} <wait>",
        "fb=false debconf/frontend=noninteractive <wait>",
        "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA keyboard-configuration/variant=USA console-setup/ask_detect=false <wait>",
        "initrd=/install/initrd.gz -- <enter><wait>"
      ]