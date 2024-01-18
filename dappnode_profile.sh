#!/bin/bash

export BIND_VERSION="${BIND_VERSION:-0.2.9}"
export IPFS_VERSION="${IPFS_VERSION:-0.2.22}"
export VPN_VERSION="${VPN_VERSION:-0.2.8}"
export DAPPMANAGER_VERSION="${DAPPMANAGER_VERSION:-0.2.81}"
export WIFI_VERSION="${WIFI_VERSION:-0.2.9}"
export WIREGUARD_VERSION="${WIREGUARD_VERSION:-0.1.2}"
export HTTPS_VERSION="${HTTPS:-0.2.1}"

export DAPPNODE_DIR="/usr/src/dappnode"
export DAPPNODE_CORE_DIR="${DAPPNODE_DIR}/DNCORE"

#!ISOBUILD Do not modify, variables above imported for ISO build
DNCORE_YMLS=$(find $DAPPNODE_CORE_DIR -name "docker-compose-*.yml" -printf "-f %p ")
# shellcheck disable=SC2207
# shellcheck disable=SC2034
DNCORE_YMLS_ARRAY=($(find /usr/src/dappnode/DNCORE -name "docker-compose-*.yml" | sort))

# Returns docker core containers status
alias dappnode_status='docker-compose $DNCORE_YMLS ps'
# Stop docker core containers
alias dappnode_stop='docker-compose $DNCORE_YMLS stop && docker stop $(docker container ls -a -q -f name=DAppNode*)'
# Start docker core containers
alias dappnode_start='docker-compose $DNCORE_YMLS up -d && docker start $(docker container ls -a -q -f name=DAppNode*)'
# Return open-vpn credentials from a specific user. e.g: dappnode_get dappnode_admin
alias dappnode_openvpn_get='docker exec -i DAppNodeCore-vpn.dnp.dappnode.eth vpncli get'
# Return open-vpn admin credentials
alias dappnode_openvpn='docker exec -i DAppNodeCore-vpn.dnp.dappnode.eth getAdminCredentials'
# Return wifi credentials (ssid and password)
alias dappnode_wifi='cat /usr/src/dappnode/DNCORE/docker-compose-wifi.yml | grep "SSID\|WPA_PASSPHRASE"'
# Return remote credentials in plain text. OPTIONS:
# --qr (QR format). --local (local creds for NAT loopback issues)
alias dappnode_wireguard='docker exec -i DAppNodeCore-api.wireguard.dnp.dappnode.eth getWireguardCredentials'
# Execute access_credentials.sh script to check for connectivity methods
alias dappnode_connect='/usr/bin/bash /usr/src/dappnode/scripts/dappnode_access_credentials.sh'
# Return all available commands
alias dappnode_help='echo -e "\n\tDAppNode commands available:\n\n\tdappnode_help\t\tprints out this message\n\n\tdappnode_wifi\t\tget wifi credentials (SSID and password)\n\n\tdappnode_openvpn\tget Open VPN credentials\n\n\tdappnode_wireguard\tget Wireguard VPN credentials (dappnode_wireguard --help for more info)\n\n\tdappnode_connect\tcheck connectivity methods available in DAppNode\n\n\tdappnode_status\t\tget status of dappnode containers\n\n\tdappnode_start\t\tstart dappnode containers\n\n\tdappnode_stop\t\tstop dappnode containers\n"'
# Compose alias for backward compatibility
if docker compose version >/dev/null 2>&1; then
    alias docker-compose='docker compose'
fi

return
