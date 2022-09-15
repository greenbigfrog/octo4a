#!/bin/bash

set -e
COL='\033[1;32m'
NC='\033[0m' # No Color
echo -e "${COL}Setting up mainsail"

read -p "Do you have \"Plugin extras\" installed? (y/n): " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo -e "${COL}\nPlease go to settings and install plugin extras${NC}"
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

echo -e "${COL}Installing dependencies...\n${NC}"
# install required dependencies
apk add curl nginx openrc

echo -e "${COL}Downloading mainsail\n${NC}"
mkdir /mainsail && cd /mainsail
curl -o mainsail.zip -L https://github.com/mainsail-crew/mainsail/releases/download/v2.3.0/mainsail.zip

echo -e "${COL}Extracting mainsail\n${NC}"
unzip mainsail.zip
rm -rf mainsail.zip

# TODO: curl and mv nginx conf
# curl -o /etc/nginx/http.d/mainsail.conf -C - https://github.com/

# TODO: sed nginx user root

# nginx serves ts as wrong mimetype
# video/mp2t                                       ts;
#text/javascript			ts;

mkdir -p /root/extensions/mainsail
cat << EOF > /root/extensions/mainsail/manifest.json
{
        "title": "mainsail plugin",
        "description": "Requires Klipper, and becomes usefull after installing Mainsail"
}
EOF

cat << EOF > /root/extensions/mainsail/start.sh
#!/bin/sh
nginx
EOF

cat << EOF > /root/extensions/mainsail/kill.sh
#!/bin/sh
nginx -s stop
EOF

chmod +x /root/extensions/mainsail/start.sh
chmod +x /root/extensions/mainsail/kill.sh
chmod 777 /root/extensions/mainsail/start.sh
chmod 777 /root/extensions/mainsail/kill.sh

cat << EOF ${COL}
mainsail installed!
TODO:
Please kill the app and restart it again to see it in extension settings${NC}
EOF