#!/bin/bash
check_ip_validity() {
    local host_name=$1
    local local_ip=$2
    local dns_server=$3
    local real_ip=$(host "$host_name" "$dns_server" 2>/dev/null | awk '/has address/ {print $NF}' | head -n 1)

    if [ -n "$real_ip" ] && [ "$local_ip" != "$real_ip" ]; then
        echo "Bogus IP for $host_name ($local_ip) in /etc/hosts! Real IP: $real_ip"
    fi
}

#citim fisierul /etc/hosts si apelam functia
grep -v '^[[:space:]]#' /etc/hosts | grep -v '^[[:space:]]$' | while read -r ip hostname aliases; do
    if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        check_ip_validity "$hostname" "$ip" "8.8.8.8"
    fi
done
