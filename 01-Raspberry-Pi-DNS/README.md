# Raspberry Pi Network-Wide DNS Filtering & Automated Recovery

## Project Overview

I configured a Raspberry Pi Zero running Raspberry Pi OS to act as a DNS filtering server for my home network using AdGuard Home.

The purpose of this project was to gain hands-on experience with Linux administration, DNS configuration, network troubleshooting, and service automation.

After experiencing DNS service interruptions, I worked on improving the server's reliability by implementing automated health checks and service recovery using Bash scripting and systemd.

## Hardware and Software

| Component | Description |
|---|---|
| Hardware | Raspberry Pi Zero |
| Operating System | Raspberry Pi OS (Debian 13/Trixie) |
| DNS Software | AdGuard Home |
| Firewall | UFW |
| Automation | Bash and systemd |
| Remote Administration | SSH |
| Network Router | TP-Link AXE5400 |

## Network Configuration

The Raspberry Pi operates as a DNS server on my local network.

- **DNS protocol:** UDP/TCP
- **DNS port:** 53
- **DNS filtering:** AdGuard Home
- **Remote management:** SSH
- **Network:** Private home LAN

The router continues to handle normal routing and network connectivity while AdGuard Home provides DNS filtering.

## DNS Server Configuration

Installed and configured AdGuard Home to process DNS queries from network devices.

This allowed me to gain practical experience with DNS resolution, filtering rules, upstream DNS providers, and DNS troubleshooting.

## Automated Health Monitoring

After encountering issues with DNS availability, I implemented a Bash health-check script.

The script:

1. Checks DNS resolution for multiple domains, including Google, Cloudflare, and Microsoft.
2. Retries failed DNS checks.
3. Tests external DNS resolvers to help determine whether the problem is local.
4. Restarts AdGuard Home when the local DNS service is failing but external resolution is working.
5. Uses a 15-minute cooldown to prevent repeated automatic restarts.

## Systemd Automation

Configured a systemd service and timer to execute the DNS health-check script approximately every minute.

Also configured systemd to restart the AdGuard Home service after unexpected failures.

This provided two recovery mechanisms:

- Automatic service restart when the application exits unexpectedly.
- DNS health monitoring to identify failures even when the service process is still running.

## Firewall Configuration

Used UFW to manage network access to the Raspberry Pi.

Configured access for DNS services, remote administration, and the AdGuard Home management interface.

## Troubleshooting Experience

During this project, I investigated several DNS service interruptions.

Troubleshooting included:

- Checking systemd service status.
- Reviewing AdGuard Home logs.
- Testing DNS resolution.
- Investigating upstream DNS connection failures.
- Reviewing firewall and network settings.
- Implementing automated recovery to reduce manual intervention.

One issue involved HTTPS-based upstream DNS connection failures, which required investigating TLS and DNS-related errors.

## Skills Demonstrated

- Linux system administration
- DNS configuration and troubleshooting
- SSH remote management
- Bash scripting
- Systemd services and timers
- Firewall administration
- Network service monitoring
- Automated service recovery

## Future Improvements

- Implement centralized monitoring with Zabbix.
- Configure alert notifications for DNS outages.
- Add a secondary DNS server using an HP EliteDesk.
- Improve monitoring and logging.
- Document service availability and recovery testing.

## Project Status

Operational home lab project with ongoing monitoring and improvements.
