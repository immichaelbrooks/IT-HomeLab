#!/bin/bash

# AdGuard Home DNS Health Monitor
# Raspberry Pi LAN DNS: 192.168.0.161

DNS_SERVER="192.168.0.161"
LOG_TAG="adguard-healthcheck"
STATE_FILE="/run/adguard-healthcheck.last-restart"

DOMAINS=("google.com" "cloudflare.com" "microsoft.com")
COOLDOWN=900  # 15 minutes

log() {
    logger -t "$LOG_TAG" "$1"
}

dns_works() {
    local server="$1"
    local domain="$2"

    dig @"$server" "$domain" A \
        +time=2 +tries=1 +short 2>/dev/null |
        grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\.$|^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'
}

restart_adguard() {
    local now last=0

    now=$(date +%s)

    if [[ -f "$STATE_FILE" ]]; then
        read -r last < "$STATE_FILE"
        [[ "$last" =~ ^[0-9]+$ ]] || last=0
    fi

    if (( now >= last && now - last < COOLDOWN )); then
        log "Restart skipped: 15-minute cooldown active"
        return 0
    fi

    log "Attempting AdGuard Home restart"
    echo "$now" > "$STATE_FILE"

    if systemctl restart AdGuardHome; then
        log "AdGuard Home restart completed"
    else
        log "ERROR: AdGuard Home restart failed"
        return 1
    fi
}

# Check whether the service is active.
if ! systemctl is-active --quiet AdGuardHome; then
    log "AdGuard Home service is inactive"
    restart_adguard
    exit $?
fi

# Run three rounds of DNS checks.
for attempt in 1 2 3; do
    for domain in "${DOMAINS[@]}"; do
        if dns_works "$DNS_SERVER" "$domain"; then
            exit 0
        fi
    done

    if (( attempt < 3 )); then
        sleep 5
    fi
done

log "WARNING: All local DNS checks failed"

# Test public DNS independently.
if dns_works "1.1.1.1" "google.com" ||
   dns_works "8.8.8.8" "google.com"; then

    log "Public DNS works but AdGuard Home does not"
    restart_adguard
else
    log "Public DNS also failed; skipping restart"
fi

exit 0
