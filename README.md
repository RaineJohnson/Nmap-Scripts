# Nmap Scripting Engine (NSE) — Custom Scripts

Custom Nmap NSE scripts for targeted reconnaissance, service enumeration, and vulnerability discovery. Each script is designed for specific use cases encountered during penetration testing and network auditing.

## Scripts

### `ssl-cert-audit.nse`
**Category:** Safe, Discovery  
**Purpose:** Extracts SSL/TLS certificate details and flags security issues — expired certs, weak signature algorithms (SHA-1), short key lengths (<2048-bit RSA), and certificates expiring within 30 days.

```bash
nmap --script ssl-cert-audit -p 443 target.com
```

**Example output:**
```
PORT    STATE SERVICE
443/tcp open  https
| ssl-cert-audit:
|   Subject: CN=target.com
|   Issuer: Let's Encrypt Authority X3
|   Valid: 2025-01-15 to 2025-04-15
|   Key: RSA 2048-bit
|   Signature: SHA-256
|   WARNING: Certificate expires in 12 days
|_  STATUS: REVIEW RECOMMENDED
```

---

### `http-header-security.nse`
**Category:** Safe, Discovery  
**Purpose:** Checks HTTP response headers against security best practices. Flags missing headers (Content-Security-Policy, X-Frame-Options, Strict-Transport-Security, X-Content-Type-Options) and insecure configurations.

```bash
nmap --script http-header-security -p 80,443 target.com
```

**Example output:**
```
PORT    STATE SERVICE
443/tcp open  https
| http-header-security:
|   Strict-Transport-Security: PRESENT (max-age=31536000)
|   Content-Security-Policy: MISSING
|   X-Frame-Options: MISSING
|   X-Content-Type-Options: PRESENT (nosniff)
|   Referrer-Policy: MISSING
|_  SCORE: 2/5 headers configured
```

---

### `smb-share-enum.nse`
**Category:** Safe, Discovery  
**Purpose:** Enumerates accessible SMB shares on a target, checks for anonymous/guest access, and lists share permissions. Useful for identifying overly permissive file shares during internal network assessments.

```bash
nmap --script smb-share-enum -p 445 10.0.0.0/24
```

---

### `dns-zone-check.nse`
**Category:** Safe, Discovery  
**Purpose:** Attempts DNS zone transfer (AXFR) and reports on DNS security configuration. Checks for open recursion, DNSSEC status, and common misconfigurations.

```bash
nmap --script dns-zone-check -p 53 ns1.target.com
```

---

## Usage Notes

**Run all custom scripts against a target:**
```bash
nmap --script ./custom-scripts/ -p 80,443,445,53 target.com
```

**Combine with default NSE scripts:**
```bash
nmap -sV --script default,./custom-scripts/ target.com
```

**Output to all formats for reporting:**
```bash
nmap --script ./custom-scripts/ -oA scan-results target.com
```

## Writing NSE Scripts — Key Concepts

Each script in this repo follows this structure:

```lua
-- Script metadata
description = [[
  Brief description of what this script does.
]]

author = "Raine Johnson"
license = "Same as Nmap"
categories = {"safe", "discovery"}

-- Dependencies
local shortport = require "shortport"
local stdnse = require "stdnse"

-- Port rule: when should this script run?
portrule = shortport.port_or_service({443}, "https")

-- Action: what does the script do?
action = function(host, port)
    -- Script logic here
    return output
end
```

## Responsible Use

These scripts are designed for authorized security testing only. Always ensure you have written permission before scanning any network or system you don't own. Unauthorized scanning may violate the Computer Fraud and Abuse Act (CFAA) and similar laws.

## Technologies

![Nmap](https://img.shields.io/badge/-Nmap-4682B4?style=flat&logo=nmap&logoColor=white)
![Lua](https://img.shields.io/badge/-Lua-2C2D72?style=flat&logo=lua&logoColor=white)
![Wireshark](https://img.shields.io/badge/-Wireshark-1679A7?style=flat&logo=Wireshark&logoColor=white)
