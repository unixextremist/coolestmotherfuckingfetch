#!/bin/sh
OS=$(uname -s)
UP=$(uptime | awk -F, '{print $1}' | sed 's/.*up //')
case "$OS" in
    Linux)
        [ -f /etc/os-release ] && DI=$(. /etc/os-release && echo "$NAME") || DI="Linux"
        KE=$(uname -r)
        read -r _ T _ < /proc/meminfo
        read -r _ F _ < /proc/meminfo
        read -r _ B _ < /proc/meminfo
        read -r _ C _ < /proc/meminfo
        RM="$(((T - F - B - C) / 1024))MB / $((T / 1024))MB"
        ;;
    *BSD)
        DI="$OS"
        KE=$(uname -r)
        T=$(sysctl -n hw.physmem)
        P=$(sysctl -n hw.pagesize)
        F=$(sysctl -n vm.stats.vm.v_free_count 2>/dev/null || echo 0)
        RM="$(((T - (F * P)) / 1024 / 1024))MB / $((T / 1024 / 1024))MB"
        ;;
esac
printf "%s@%s\n------------------------\n" "$(whoami)" "$(hostname)"
printf -- "%-9s %s\n" "os -" "$DI" "kernel -" "$KE" "up -" "$UP" "shell -" "$(basename "$SHELL")" "ram -" "$RM"
