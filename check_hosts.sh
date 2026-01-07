#!/bin/bash
grep -v '^[[:space:]]#' /etc/hosts | grep -v '^[[:space:]]$' | while read -r ip hostname aliases; do
    if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        real_ip=$(host "$hostname" 8.8.8.8 2>/dev/null | awk '/has address/ {print $NF}' | head -n 1)
        if [ -n "$real_ip" ] && [ "$ip" != "$real_ip" ]; then
            echo "Bogus IP for $hostname ($ip) in /etc/hosts! Real IP: $real_ip"
        fi
    fi
done
