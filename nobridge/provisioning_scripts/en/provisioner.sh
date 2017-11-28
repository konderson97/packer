#!/bin/bash

wget –quiet -O peer_cmd.sh https://raw.githubusercontent.com/subutai-io/packer/master/nobridge/provisioning_scripts/en/peer_cmd.sh
wget –quiet -O final_message.sh https://raw.githubusercontent.com/subutai-io/packer/master/nobridge/provisioning_scripts/en/final_message.sh
wget –quiet -O rhost_message.sh https://raw.githubusercontent.com/subutai-io/packer/master/nobridge/provisioning_scripts/en/rhost_message.sh
wget –quiet -O system_checks.sh https://raw.githubusercontent.com/subutai-io/packer/master/nobridge/provisioning_scripts/en/en/system_checks.sh
wget –quiet -O insecure.sh https://raw.githubusercontent.com/subutai-io/packer/master/nobridge/provisioning_scripts/en/en/insecure.sh

chmod +x *.sh

case $SUBUTAI_ENV in
  dev*)
    CMD="subutai-dev"
    ;;
  stage)
    CMD="subutai-master"
    ;;
  master)
    CMD="subutai-master"
    ;;
  prod*)
    CMD="subutai"
    ;;
  *)
    CMD="subutai"
esac

echo "Installing $CMD Snap ..."
snap install $CMD --devmode --beta 2> snap.err
if [ $? -ne 0 ]; then exit 1; fi

echo "Mounting container storage ..."
/snap/$CMD/current/bin/btrfsinit /dev/mapper/main-btrfs &> /dev/null
if [ $? -ne 0 ]; then exit 1; fi

if [ $ALLOW_INSECURE -eq true ]; then
  CMD=$CMD ./insecure.sh
  if [ $? -ne 0 ]; then exit 1; fi
fi

if [ $SUBUTAI_PEER -eq true ]; then
  CMD=$CMD ./peer_cmd.sh
  if [ $? -ne 0 ]; then exit 1; fi
else
  ./rhost_message.sh
fi

CONSOLE_PORT=$CONSOLE_PORT ./final_message.sh
rm *.sh    
