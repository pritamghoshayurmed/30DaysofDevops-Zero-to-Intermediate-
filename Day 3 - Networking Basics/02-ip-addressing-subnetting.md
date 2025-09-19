# 🔢 IP Addressing and Subnetting

<div align="center">
  <h2 style="color: #2E8B57;">Master the Art of Network Addressing and Subnet Design</h2>
  <p><em>From Basic IP Concepts to Advanced Subnetting Techniques</em></p>
</div>

---

## 📋 Table of Contents

- [🌐 IP Addressing Fundamentals](#-ip-addressing-fundamentals)
- [📊 CIDR Notation Explained](#-cidr-notation-explained)
- [🔧 Subnetting Step-by-Step](#-subnetting-step-by-step)
- [🎯 VLSM (Variable Length Subnet Masking)](#-vlsm-variable-length-subnet-masking)
- [🌍 IPv6 Introduction](#-ipv6-introduction)
- [🧮 Subnetting Calculator](#-subnetting-calculator)
- [💻 Practical Examples](#-practical-examples)
- [🧪 Hands-on Labs](#-hands-on-labs)
- [❓ Practice Problems](#-practice-problems)

---

## 🌐 IP Addressing Fundamentals

### <span style="color: #FF6347;">📚 What is an IP Address?</span>

An **IP (Internet Protocol) address** is a unique numerical label assigned to each device in a computer network. Think of it as a **postal address** for network communication.

**IPv4 Address Structure**:
```
192.168.1.100
│   │   │ │
│   │   │ └── Host portion (device identifier)
│   │   └──── Network portion (subnet identifier)
│   └──────── Network class indicator
└─────────── Network identifier
```

### <span style="color: #4169E1;">🔢 Binary vs Decimal Representation</span>

Every IP address is actually a **32-bit binary number** divided into 4 octets (8-bit sections):

```bash
# Decimal:     192.168.1.100
# Binary:      11000000.10101000.00000001.01100100
# Hex:         C0.A8.01.64

# Quick conversion commands
printf "%d.%d.%d.%d\n" 0x{C0,A8,01,64}    # Hex to decimal
printf "%02X.%02X.%02X.%02X\n" {192,168,1,100}    # Decimal to hex
```

**Binary to Decimal Conversion Table**:
```
┌─────────┬─────────┬─────────┬─────────┬─────────┬─────────┬─────────┬─────────┐
│ Position│   128   │   64    │   32    │   16    │    8    │    4    │    2    │    1    │
├─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Binary  │    1    │    1    │    0    │    0    │    0    │    0    │    0    │    0    │
└─────────┴─────────┴─────────┴─────────┴─────────┴─────────┴─────────┴─────────┴─────────┘
Result: 128 + 64 = 192
```

### <span style="color: #32CD32;">🏠 IP Address Classes (Legacy)</span>

**Traditional Class-based Addressing**:
```
┌───────┬──────────────────┬──────────────┬──────────────┬─────────────────┐
│ Class │   Range          │ Default Mask │ Network Bits │ Max Hosts       │
├───────┼──────────────────┼──────────────┼──────────────┼─────────────────┤
│   A   │ 1.0.0.0 - 126.*  │ 255.0.0.0    │     /8       │ 16,777,214      │
│   B   │ 128.0.* - 191.*  │ 255.255.0.0  │     /16      │ 65,534          │
│   C   │ 192.0.* - 223.*  │255.255.255.0 │     /24      │ 254             │
│   D   │ 224.* - 239.*    │ Multicast    │     N/A      │ N/A             │
│   E   │ 240.* - 255.*    │ Reserved     │     N/A      │ N/A             │
└───────┴──────────────────┴──────────────┴──────────────┴─────────────────┘
```

**Practice with Class Identification**:
```bash
# Identify the class of these IP addresses:
# 10.0.0.1      → Class A (starts with 10)
# 172.16.0.1    → Class B (starts with 172)
# 192.168.1.1   → Class C (starts with 192)

# Command to check IP class programmatically
ip_class() {
    local ip=$1
    local first_octet=$(echo $ip | cut -d. -f1)
    
    if [ $first_octet -le 126 ]; then
        echo "Class A"
    elif [ $first_octet -le 191 ]; then
        echo "Class B"
    else
        echo "Class C"
    fi
}

ip_class "192.168.1.1"    # Output: Class C
```

### <span style="color: #9370DB;">🔒 Private vs Public IP Addresses</span>

**Private IP Ranges (RFC 1918)**:
```bash
# Class A Private: 10.0.0.0/8
# Range: 10.0.0.0 - 10.255.255.255
# Usable: 16,777,216 addresses

# Class B Private: 172.16.0.0/12
# Range: 172.16.0.0 - 172.31.255.255
# Usable: 1,048,576 addresses

# Class C Private: 192.168.0.0/16
# Range: 192.168.0.0 - 192.168.255.255
# Usable: 65,536 addresses

# Check if IP is private
check_private_ip() {
    local ip=$1
    local first_octet=$(echo $ip | cut -d. -f1)
    local second_octet=$(echo $ip | cut -d. -f2)
    
    if [[ $first_octet -eq 10 ]]; then
        echo "Private (Class A)"
    elif [[ $first_octet -eq 172 && $second_octet -ge 16 && $second_octet -le 31 ]]; then
        echo "Private (Class B)"
    elif [[ $first_octet -eq 192 && $second_octet -eq 168 ]]; then
        echo "Private (Class C)"
    else
        echo "Public IP"
    fi
}
```

**Special IP Addresses**:
```bash
# Loopback addresses
127.0.0.0/8          # 127.0.0.1 - 127.255.255.255
ping 127.0.0.1       # Test local network stack

# Link-local addresses (APIPA)
169.254.0.0/16       # Auto-assigned when DHCP fails

# Multicast addresses
224.0.0.0/4          # 224.0.0.0 - 239.255.255.255

# Broadcast addresses
255.255.255.255      # Limited broadcast
192.168.1.255/24     # Directed broadcast (subnet broadcast)

# Network address
192.168.1.0/24       # Network identifier (hosts are .1-.254)
```

---

## 📊 CIDR Notation Explained

### <span style="color: #FF4500;">🎯 Understanding CIDR</span>

**CIDR (Classless Inter-Domain Routing)** replaces the old class-based system with a more flexible approach.

**Format**: `Network_Address/Prefix_Length`

```
Example: 192.168.1.0/24
         │           │
         │           └── Prefix length (24 bits for network)
         └────────────── Network address
```

### <span style="color: #B8860B;">📏 Subnet Mask Conversion</span>

**CIDR to Subnet Mask Conversion**:
```bash
/8   = 255.0.0.0         # 11111111.00000000.00000000.00000000
/16  = 255.255.0.0       # 11111111.11111111.00000000.00000000
/24  = 255.255.255.0     # 11111111.11111111.11111111.00000000
/25  = 255.255.255.128   # 11111111.11111111.11111111.10000000
/26  = 255.255.255.192   # 11111111.11111111.11111111.11000000
/27  = 255.255.255.224   # 11111111.11111111.11111111.11100000
/28  = 255.255.255.240   # 11111111.11111111.11111111.11110000
/29  = 255.255.255.248   # 11111111.11111111.11111111.11111000
/30  = 255.255.255.252   # 11111111.11111111.11111111.11111100
```

**Calculate subnet mask from CIDR**:
```bash
# Function to convert CIDR to subnet mask
cidr_to_mask() {
    local cidr=$1
    local mask=""
    local full_octets=$((cidr / 8))
    local partial_octet=$((cidr % 8))
    
    # Full octets
    for ((i=0; i<full_octets; i++)); do
        mask="${mask}255."
    done
    
    # Partial octet
    if [ $partial_octet -gt 0 ]; then
        local partial_value=$((256 - 2**(8-partial_octet)))
        mask="${mask}${partial_value}."
    fi
    
    # Remaining octets
    local remaining=$((4 - full_octets - (partial_octet > 0 ? 1 : 0)))
    for ((i=0; i<remaining; i++)); do
        mask="${mask}0."
    done
    
    # Remove trailing dot
    echo ${mask%?}
}

cidr_to_mask 24    # Output: 255.255.255.0
cidr_to_mask 26    # Output: 255.255.255.192
```

### <span style="color: #DC143C;">🧮 Network Calculations</span>

**Key Formulas**:
```bash
# Number of possible hosts
Hosts = 2^(32 - CIDR) - 2
# Subtract 2 for network address and broadcast address

# Number of possible subnets
Subnets = 2^(borrowed bits)

# Examples:
# /24 network: 2^(32-24) - 2 = 2^8 - 2 = 254 hosts
# /25 network: 2^(32-25) - 2 = 2^7 - 2 = 126 hosts
# /26 network: 2^(32-26) - 2 = 2^6 - 2 = 62 hosts
```

**Network Range Calculator**:
```bash
calculate_network() {
    local ip=$1
    local cidr=$2
    
    # Convert IP to decimal
    IFS='.' read -r a b c d <<< "$ip"
    local decimal_ip=$((a*256**3 + b*256**2 + c*256 + d))
    
    # Calculate network address
    local host_bits=$((32 - cidr))
    local network_decimal=$((decimal_ip & (0xFFFFFFFF << host_bits)))
    
    # Convert back to dotted decimal
    local net_a=$((network_decimal >> 24 & 255))
    local net_b=$((network_decimal >> 16 & 255))
    local net_c=$((network_decimal >> 8 & 255))
    local net_d=$((network_decimal & 255))
    
    echo "Network: $net_a.$net_b.$net_c.$net_d"
    
    # Calculate broadcast address
    local broadcast_decimal=$((network_decimal | (2**host_bits - 1)))
    local bc_a=$((broadcast_decimal >> 24 & 255))
    local bc_b=$((broadcast_decimal >> 16 & 255))
    local bc_c=$((broadcast_decimal >> 8 & 255))
    local bc_d=$((broadcast_decimal & 255))
    
    echo "Broadcast: $bc_a.$bc_b.$bc_c.$bc_d"
    echo "Hosts: $((2**host_bits - 2))"
}

calculate_network "192.168.1.100" 24
# Output:
# Network: 192.168.1.0
# Broadcast: 192.168.1.255
# Hosts: 254
```

---

## 🔧 Subnetting Step-by-Step

### <span style="color: #228B22;">🎯 Why Subnet?</span>

**Benefits of Subnetting**:
- **Efficient IP utilization**: Use only needed addresses
- **Improved performance**: Smaller broadcast domains
- **Enhanced security**: Separate network segments
- **Better organization**: Logical network division

### <span style="color: #FF1493;">📝 Subnetting Process</span>

**Step-by-Step Method**:

#### **Step 1: Understand Requirements**
```
Given: 192.168.1.0/24
Task: Create 4 subnets with at least 50 hosts each

Analysis:
- Original network: 192.168.1.0/24 (254 hosts)
- Need: 4 subnets × 50 hosts = 200 hosts minimum
- Available: 254 hosts ✓ (sufficient)
```

#### **Step 2: Calculate Required Subnet Bits**
```bash
# To create 4 subnets, we need 2^n ≥ 4
# Therefore, n = 2 bits for subnetting
# New subnet mask: /24 + 2 = /26

# Verification:
# 2^2 = 4 subnets ✓
# Host bits remaining: 32 - 26 = 6 bits
# Hosts per subnet: 2^6 - 2 = 62 hosts ✓ (≥ 50 required)
```

#### **Step 3: Calculate Subnet Addresses**
```bash
# Subnet increment: 2^6 = 64 addresses per subnet

# Subnet 1: 192.168.1.0/26
# Range: 192.168.1.0 - 192.168.1.63
# Network: 192.168.1.0
# Broadcast: 192.168.1.63
# Hosts: 192.168.1.1 - 192.168.1.62

# Subnet 2: 192.168.1.64/26
# Range: 192.168.1.64 - 192.168.1.127
# Network: 192.168.1.64
# Broadcast: 192.168.1.127
# Hosts: 192.168.1.65 - 192.168.1.126

# Subnet 3: 192.168.1.128/26
# Range: 192.168.1.128 - 192.168.1.191
# Network: 192.168.1.128
# Broadcast: 192.168.1.191
# Hosts: 192.168.1.129 - 192.168.1.190

# Subnet 4: 192.168.1.192/26
# Range: 192.168.1.192 - 192.168.1.255
# Network: 192.168.1.192
# Broadcast: 192.168.1.255
# Hosts: 192.168.1.193 - 192.168.1.254
```

### <span style="color: #20B2AA;">🔄 Advanced Subnetting Example</span>

**Complex Scenario**:
```
Given: 172.16.0.0/16
Requirements:
- Subnet A: 1000 hosts
- Subnet B: 500 hosts
- Subnet C: 250 hosts
- Subnet D: 100 hosts
```

**Solution Process**:
```bash
# Step 1: Determine host bits needed for each subnet
# Subnet A: 1000 hosts → need 2^n ≥ 1002 → n = 10 bits → /22
# Subnet B: 500 hosts → need 2^n ≥ 502 → n = 9 bits → /23
# Subnet C: 250 hosts → need 2^n ≥ 252 → n = 8 bits → /24
# Subnet D: 100 hosts → need 2^n ≥ 102 → n = 7 bits → /25

# Step 2: Assign subnets (largest first)
# Subnet A (/22): 172.16.0.0/22
# Range: 172.16.0.0 - 172.16.3.255 (1022 hosts)

# Subnet B (/23): 172.16.4.0/23  
# Range: 172.16.4.0 - 172.16.5.255 (510 hosts)

# Subnet C (/24): 172.16.6.0/24
# Range: 172.16.6.0 - 172.16.6.255 (254 hosts)

# Subnet D (/25): 172.16.7.0/25
# Range: 172.16.7.0 - 172.16.7.127 (126 hosts)
```

**Verification Script**:
```bash
#!/bin/bash
verify_subnetting() {
    local base_network="172.16.0.0"
    local base_cidr=16
    
    echo "=== Subnetting Verification ==="
    
    # Define subnets
    declare -a subnets=(
        "172.16.0.0/22,Subnet_A,1022"
        "172.16.4.0/23,Subnet_B,510" 
        "172.16.6.0/24,Subnet_C,254"
        "172.16.7.0/25,Subnet_D,126"
    )
    
    for subnet_info in "${subnets[@]}"; do
        IFS=',' read -r network name hosts <<< "$subnet_info"
        echo "├─ $name: $network"
        echo "│  └─ Available hosts: $hosts"
    done
}

verify_subnetting
```

---

## 🎯 VLSM (Variable Length Subnet Masking)

### <span style="color: #4682B4;">🔧 VLSM Concepts</span>

**VLSM** allows different subnet masks within the same network, optimizing IP address usage.

**Benefits**:
- **Efficient address utilization**: No wasted IPs
- **Scalable design**: Different sized subnets
- **Hierarchical addressing**: Organized structure

### <span style="color: #CD5C5C;">📋 VLSM Design Process</span>

**Scenario**: Design network for a company
```
Requirements:
- Sales Department: 120 hosts
- Engineering: 60 hosts  
- HR: 30 hosts
- Management: 10 hosts
- Point-to-point links: 2 each (×3 links)

Available: 192.168.1.0/24
```

**VLSM Solution**:
```bash
# Step 1: List requirements (largest to smallest)
# Sales: 120 hosts → need /25 (126 hosts available)
# Engineering: 60 hosts → need /26 (62 hosts available)  
# HR: 30 hosts → need /27 (30 hosts available)
# Management: 10 hosts → need /28 (14 hosts available)
# P2P Links: 2 hosts each → need /30 (2 hosts available) × 3

# Step 2: Assign subnets sequentially
# Sales: 192.168.1.0/25 (192.168.1.0 - 192.168.1.127)
# Engineering: 192.168.1.128/26 (192.168.1.128 - 192.168.1.191)
# HR: 192.168.1.192/27 (192.168.1.192 - 192.168.1.223)
# Management: 192.168.1.224/28 (192.168.1.224 - 192.168.1.239)
# P2P Link 1: 192.168.1.240/30 (192.168.1.240 - 192.168.1.243)
# P2P Link 2: 192.168.1.244/30 (192.168.1.244 - 192.168.1.247)
# P2P Link 3: 192.168.1.248/30 (192.168.1.248 - 192.168.1.251)
```

**VLSM Planning Script**:
```bash
#!/bin/bash

calculate_vlsm() {
    local base_network="192.168.1.0"
    local current_address=0
    
    # Department requirements (hosts needed)
    declare -A departments=(
        ["Sales"]=120
        ["Engineering"]=60
        ["HR"]=30
        ["Management"]=10
    )
    
    # Point-to-point links
    declare -A p2p_links=(
        ["Link1"]=2
        ["Link2"]=2
        ["Link3"]=2
    )
    
    echo "=== VLSM Network Design ==="
    echo "Base Network: $base_network/24"
    echo ""
    
    # Process departments
    for dept in $(printf '%s\n' "${!departments[@]}" | sort -rn -t$'\t' -k2); do
        local required_hosts=${departments[$dept]}
        local subnet_bits=$(get_subnet_bits $required_hosts)
        local cidr=$((32 - subnet_bits))
        local available_hosts=$((2**subnet_bits - 2))
        
        printf "%-15s: 192.168.1.%-3d/%d (Hosts: %d)\n" \
            "$dept" "$current_address" "$cidr" "$available_hosts"
        
        current_address=$((current_address + 2**subnet_bits))
    done
    
    # Process P2P links  
    echo ""
    echo "Point-to-Point Links:"
    for link in "${!p2p_links[@]}"; do
        printf "%-15s: 192.168.1.%-3d/30 (Hosts: 2)\n" \
            "$link" "$current_address"
        current_address=$((current_address + 4))
    done
    
    echo ""
    echo "Total addresses used: $current_address/256"
    echo "Remaining addresses: $((256 - current_address))"
}

get_subnet_bits() {
    local hosts_needed=$1
    local bits=1
    
    while [ $((2**bits - 2)) -lt $hosts_needed ]; do
        bits=$((bits + 1))
    done
    
    echo $bits
}

calculate_vlsm
```

---

## 🌍 IPv6 Introduction

### <span style="color: #FF6347;">🚀 Why IPv6?</span>

**IPv4 Limitations**:
- Only 4.3 billion addresses (2^32)
- Address exhaustion (IANA pool depleted in 2011)
- NAT complexity
- Limited security features

**IPv6 Advantages**:
- 340 undecillion addresses (2^128)
- Built-in security (IPSec)
- No NAT required
- Simplified header structure

### <span style="color: #4169E1;">📊 IPv6 Address Format</span>

**Structure**:
```
2001:0db8:85a3:0000:0000:8a2e:0370:7334
│    │    │    │    │    │    │    │
│    │    │    │    │    │    │    └─── Interface ID (64 bits)
│    │    │    └────┴────┴────┴──────── Interface ID (64 bits)
│    │    └─────────────────────────── Subnet ID (16 bits)  
│    └──────────────────────────────── Site Prefix (48 bits)
└───────────────────────────────────── Global Routing Prefix
```

**Address Shortening Rules**:
```bash
# Original: 2001:0db8:0000:0000:0000:0000:0000:0001
# Rule 1: Remove leading zeros
2001:db8:0:0:0:0:0:1

# Rule 2: Replace consecutive zeros with ::
2001:db8::1

# Examples:
::1                    # Loopback (127.0.0.1 equivalent)
::                     # All zeros (0.0.0.0 equivalent)
2001:db8::            # 2001:db8:0000:0000:0000:0000:0000:0000
fe80::1               # Link-local address
```

**IPv6 Commands**:
```bash
# View IPv6 addresses
ip -6 addr show                    # Linux
ifconfig | grep inet6             # Linux/macOS
netsh interface ipv6 show address # Windows

# IPv6 ping
ping6 ::1                         # Ping loopback
ping6 google.com                  # Ping Google's IPv6
ping -6 google.com                # Alternative syntax

# IPv6 traceroute
traceroute6 google.com            # Linux
tracert -6 google.com             # Windows

# Configure static IPv6
sudo ip -6 addr add 2001:db8::1/64 dev eth0    # Linux
```

### <span style="color: #32CD32;">🏠 IPv6 Address Types</span>

```bash
# Unicast addresses (one-to-one communication)
Global Unicast:    2000::/3      # Internet routable
Unique Local:      fc00::/7      # Private (RFC 4193)
Link-Local:        fe80::/10     # Local link only

# Multicast addresses (one-to-many communication)  
Multicast:         ff00::/8      # Group communication

# Anycast addresses (one-to-nearest communication)
# Same format as unicast, but multiple devices have same address

# Special addresses
Loopback:          ::1/128       # IPv4 127.0.0.1 equivalent
Unspecified:       ::/128        # IPv4 0.0.0.0 equivalent
```

**IPv6 Subnetting**:
```bash
# Standard IPv6 allocation
# ISP gives you: 2001:db8::/48
# You can create: 65,536 subnets (/64 each)

# Subnet examples:
2001:db8:0001::/64    # Subnet 1
2001:db8:0002::/64    # Subnet 2
2001:db8:0003::/64    # Subnet 3
...
2001:db8:ffff::/64    # Subnet 65,535

# Each subnet has 2^64 addresses (18 quintillion)
```

---

## 🧮 Subnetting Calculator

### <span style="color: #B8860B;">🔧 Command-Line Calculator</span>

```bash
#!/bin/bash

# Comprehensive subnetting calculator
subnet_calculator() {
    local ip=$1
    local cidr=$2
    
    echo "=== Subnet Calculator ==="
    echo "Input: $ip/$cidr"
    echo ""
    
    # Basic calculations
    local host_bits=$((32 - cidr))
    local total_addresses=$((2**host_bits))
    local usable_hosts=$((total_addresses - 2))
    local subnet_mask=$(cidr_to_mask $cidr)
    
    # Network and broadcast calculation
    IFS='.' read -r a b c d <<< "$ip"
    local decimal_ip=$((a*256**3 + b*256**2 + c*256 + d))
    local network_decimal=$((decimal_ip & (0xFFFFFFFF << host_bits)))
    local broadcast_decimal=$((network_decimal | (total_addresses - 1)))
    
    # Convert back to dotted decimal
    local net_a=$((network_decimal >> 24 & 255))
    local net_b=$((network_decimal >> 16 & 255))
    local net_c=$((network_decimal >> 8 & 255))
    local net_d=$((network_decimal & 255))
    
    local bc_a=$((broadcast_decimal >> 24 & 255))
    local bc_b=$((broadcast_decimal >> 16 & 255))
    local bc_c=$((broadcast_decimal >> 8 & 255))
    local bc_d=$((broadcast_decimal & 255))
    
    # First and last usable hosts
    local first_host_decimal=$((network_decimal + 1))
    local last_host_decimal=$((broadcast_decimal - 1))
    
    local fh_a=$((first_host_decimal >> 24 & 255))
    local fh_b=$((first_host_decimal >> 16 & 255))
    local fh_c=$((first_host_decimal >> 8 & 255))
    local fh_d=$((first_host_decimal & 255))
    
    local lh_a=$((last_host_decimal >> 24 & 255))
    local lh_b=$((last_host_decimal >> 16 & 255))
    local lh_c=$((last_host_decimal >> 8 & 255))
    local lh_d=$((last_host_decimal & 255))
    
    # Output results
    echo "Network Address:     $net_a.$net_b.$net_c.$net_d"
    echo "Subnet Mask:         $subnet_mask"
    echo "Broadcast Address:   $bc_a.$bc_b.$bc_c.$bc_d"
    echo "First Usable Host:   $fh_a.$fh_b.$fh_c.$fh_d"
    echo "Last Usable Host:    $lh_a.$lh_b.$lh_c.$lh_d"
    echo "Total Addresses:     $total_addresses"
    echo "Usable Hosts:        $usable_hosts"
    echo ""
    
    # Binary representation
    echo "Binary Breakdown:"
    echo "Network:   $(dec_to_binary $net_a).$(dec_to_binary $net_b).$(dec_to_binary $net_c).$(dec_to_binary $net_d)"
    echo "Mask:      $(dec_to_binary ${subnet_mask%%.*}).$(dec_to_binary $(echo $subnet_mask | cut -d. -f2)).$(dec_to_binary $(echo $subnet_mask | cut -d. -f3)).$(dec_to_binary ${subnet_mask##*.})"
}

# Helper functions
dec_to_binary() {
    local decimal=$1
    local binary=""
    
    for i in {7..0}; do
        if [ $((decimal & (1<<i))) -ne 0 ]; then
            binary="${binary}1"
        else
            binary="${binary}0"
        fi
    done
    
    echo $binary
}

cidr_to_mask() {
    local cidr=$1
    local mask=""
    
    for i in {1..4}; do
        if [ $cidr -ge 8 ]; then
            mask="${mask}255"
            cidr=$((cidr - 8))
        elif [ $cidr -gt 0 ]; then
            mask="${mask}$((256 - 2**(8-cidr)))"
            cidr=0
        else
            mask="${mask}0"
        fi
        
        if [ $i -lt 4 ]; then
            mask="${mask}."
        fi
    done
    
    echo $mask
}

# Usage examples
subnet_calculator "192.168.1.100" "24"
subnet_calculator "10.0.0.0" "8"
subnet_calculator "172.16.50.0" "20"
```

### <span style="color: #DC143C;">📊 Quick Reference Tables</span>

**Common CIDR Blocks**:
```
┌──────┬─────────────────┬─────────────┬────────────┐
│ CIDR │ Subnet Mask     │ Host Bits   │ Addresses  │
├──────┼─────────────────┼─────────────┼────────────┤
│ /30  │ 255.255.255.252 │     2       │     4      │
│ /29  │ 255.255.255.248 │     3       │     8      │
│ /28  │ 255.255.255.240 │     4       │    16      │
│ /27  │ 255.255.255.224 │     5       │    32      │
│ /26  │ 255.255.255.192 │     6       │    64      │
│ /25  │ 255.255.255.128 │     7       │   128      │
│ /24  │ 255.255.255.0   │     8       │   256      │
│ /23  │ 255.255.254.0   │     9       │   512      │
│ /22  │ 255.255.252.0   │    10       │  1024      │
│ /21  │ 255.255.248.0   │    11       │  2048      │
│ /20  │ 255.255.240.0   │    12       │  4096      │
└──────┴─────────────────┴─────────────┴────────────┘
```

**Powers of 2 Quick Reference**:
```
2^1  = 2        2^9  = 512      2^17 = 131,072
2^2  = 4        2^10 = 1,024    2^18 = 262,144  
2^3  = 8        2^11 = 2,048    2^19 = 524,288
2^4  = 16       2^12 = 4,096    2^20 = 1,048,576
2^5  = 32       2^13 = 8,192    2^21 = 2,097,152
2^6  = 64       2^14 = 16,384   2^22 = 4,194,304
2^7  = 128      2^15 = 32,768   2^23 = 8,388,608
2^8  = 256      2^16 = 65,536   2^24 = 16,777,216
```

---

## 💻 Practical Examples

### <span style="color: #FF4500;">🏢 Corporate Network Design</span>

**Scenario**: Design network for a medium-sized company
```
Available: 10.0.0.0/8
Departments:
- IT: 200 devices
- Sales: 150 devices  
- Marketing: 100 devices
- Finance: 50 devices
- HR: 30 devices
- Guest WiFi: 500 devices
- Servers: 20 devices
- Management: 10 devices
```

**Design Solution**:
```bash
#!/bin/bash

design_corporate_network() {
    echo "=== Corporate Network Design ==="
    echo "Base Network: 10.0.0.0/8"
    echo ""
    
    # Define requirements
    declare -A departments=(
        ["Guest_WiFi"]=500
        ["IT"]=200
        ["Sales"]=150
        ["Marketing"]=100
        ["Finance"]=50
        ["HR"]=30
        ["Servers"]=20
        ["Management"]=10
    )
    
    local current_subnet=0
    
    echo "Department Subnet Allocation:"
    echo "┌─────────────────┬─────────────────┬──────┬─────────┐"
    echo "│ Department      │ Network         │ CIDR │ Hosts   │"
    echo "├─────────────────┼─────────────────┼──────┼─────────┤"
    
    # Sort by size (largest first)
    for dept in $(printf '%s\n' "${!departments[@]}" | \
                  while read dept; do 
                      echo "${departments[$dept]} $dept"
                  done | sort -rn | cut -d' ' -f2); do
        
        local required=${departments[$dept]}
        local cidr=$(calculate_cidr $required)
        local hosts=$((2**(32-cidr) - 2))
        
        printf "│ %-15s │ 10.%d.0.0/%-6s │ /%-3s │ %-7s │\n" \
            "$dept" "$current_subnet" "$cidr" "$cidr" "$hosts"
        
        current_subnet=$((current_subnet + 1))
    done
    
    echo "└─────────────────┴─────────────────┴──────┴─────────┘"
    echo ""
    echo "Security Zones:"
    echo "- DMZ: 10.0.254.0/24 (Web servers, email)"
    echo "- Internal: 10.1-10.10.x.x (User networks)"
    echo "- Secure: 10.250.x.x (Finance, HR)"
    echo "- Management: 10.255.x.x (Network equipment)"
}

calculate_cidr() {
    local hosts_needed=$1
    local cidr=32
    
    while [ $((2**(32-cidr) - 2)) -lt $hosts_needed ]; do
        cidr=$((cidr - 1))
    done
    
    echo $cidr
}

design_corporate_network
```

### <span style="color: #228B22;">🏠 Home Network Setup</span>

**Typical Home Network**:
```bash
# Router Configuration
# WAN: DHCP (ISP assigned)
# LAN: 192.168.1.0/24

# Device allocation
Router_Gateway: 192.168.1.1
DHCP_Pool: 192.168.1.100 - 192.168.1.200
Static_Devices: 192.168.1.2 - 192.168.1.99

# Common static assignments
NAS_Server: 192.168.1.10
Printer: 192.168.1.20  
Security_Camera: 192.168.1.30
Smart_TV: 192.168.1.40
Gaming_Console: 192.168.1.50
```

**Home Network Setup Script**:
```bash
#!/bin/bash

setup_home_network() {
    echo "=== Home Network Configuration ==="
    echo "Network: 192.168.1.0/24"
    echo "Gateway: 192.168.1.1"
    echo ""
    
    # Configure static IP for server/NAS
    echo "Configuring static IP for home server..."
    
    # Ubuntu/Debian netplan configuration
    cat > /etc/netplan/01-network.yaml << EOF
network:
  version: 2
  ethernets:
    eth0:
      addresses:
        - 192.168.1.10/24
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
EOF
    
    echo "Network configuration saved to /etc/netplan/01-network.yaml"
    echo ""
    
    # Display device recommendations
    echo "Recommended IP Assignments:"
    echo "┌─────────────────────────┬─────────────────┐"
    echo "│ Device                  │ IP Address      │"
    echo "├─────────────────────────┼─────────────────┤"
    echo "│ Router/Gateway          │ 192.168.1.1     │"
    echo "│ Home Server/NAS         │ 192.168.1.10    │"
    echo "│ Network Printer         │ 192.168.1.20    │"
    echo "│ Security Cameras        │ 192.168.1.30-39 │"
    echo "│ Smart TV/Streaming      │ 192.168.1.40-49 │"
    echo "│ Gaming Devices          │ 192.168.1.50-59 │"
    echo "│ IoT Devices            │ 192.168.1.60-99 │"
    echo "│ DHCP Pool (Dynamic)     │ 192.168.1.100+  │"
    echo "└─────────────────────────┴─────────────────┘"
}

# Port forwarding configuration
setup_port_forwarding() {
    echo ""
    echo "=== Common Port Forwarding Rules ==="
    echo "SSH Server (Port 22):"
    echo "External: 2222 → Internal: 192.168.1.10:22"
    echo ""
    echo "Web Server (Port 80/443):"
    echo "External: 80 → Internal: 192.168.1.10:80"
    echo "External: 443 → Internal: 192.168.1.10:443"
    echo ""
    echo "Security Camera NVR:"
    echo "External: 8080 → Internal: 192.168.1.30:8080"
}

setup_home_network
setup_port_forwarding
```

---

## 🧪 Hands-on Labs

### <span style="color: #4169E1;">🔬 Lab 1: Basic Subnetting</span>

**Objective**: Practice subnetting calculations

```bash
#!/bin/bash

lab_basic_subnetting() {
    echo "=== Lab 1: Basic Subnetting Practice ==="
    echo ""
    
    # Lab exercises
    local exercises=(
        "192.168.1.0/24,Create 4 equal subnets"
        "10.0.0.0/8,Create 256 subnets with 65,534 hosts each"
        "172.16.0.0/16,Create 8 subnets"
        "192.168.100.0/24,Create subnets for 50, 25, 12, and 6 hosts"
    )
    
    for exercise in "${exercises[@]}"; do
        IFS=',' read -r network task <<< "$exercise"
        echo "Exercise: $network"
        echo "Task: $task"
        echo "Your answer: _______________"
        echo ""
    done
}

# Lab 1 Solutions
lab1_solutions() {
    echo "=== Lab 1 Solutions ==="
    echo ""
    
    echo "1. 192.168.1.0/24 → 4 equal subnets:"
    echo "   Need 2 bits for 4 subnets → /26"
    echo "   Subnet 1: 192.168.1.0/26 (.0-.63)"
    echo "   Subnet 2: 192.168.1.64/26 (.64-.127)" 
    echo "   Subnet 3: 192.168.1.128/26 (.128-.191)"
    echo "   Subnet 4: 192.168.1.192/26 (.192-.255)"
    echo ""
    
    echo "2. 10.0.0.0/8 → 256 subnets:"
    echo "   Need 8 bits for 256 subnets → /16"
    echo "   Range: 10.0.0.0/16 to 10.255.0.0/16"
    echo "   Each subnet: 65,534 hosts"
    echo ""
}

lab_basic_subnetting
# Uncomment to show solutions:
# lab1_solutions
```

### <span style="color: #20B2AA;">🔬 Lab 2: VLSM Design</span>

**Objective**: Design a network using VLSM

```bash
#!/bin/bash

lab_vlsm_design() {
    echo "=== Lab 2: VLSM Network Design ==="
    echo ""
    
    echo "Scenario: Design network for a school"
    echo "Available: 172.20.0.0/16"
    echo ""
    echo "Requirements:"
    echo "- Library: 500 computers"
    echo "- Classrooms: 200 computers" 
    echo "- Lab 1: 100 computers"
    echo "- Lab 2: 50 computers"
    echo "- Faculty: 30 computers"
    echo "- Administration: 15 computers"
    echo "- 3 Point-to-point links between buildings"
    echo ""
    
    echo "Design your VLSM solution:"
    echo "Department       | Network        | Subnet Mask     | Hosts"
    echo "─────────────────┼────────────────┼─────────────────┼──────"
    echo "Library          | ______________ | ______________ | ____"
    echo "Classrooms       | ______________ | ______________ | ____"
    echo "Lab 1            | ______________ | ______________ | ____"
    echo "Lab 2            | ______________ | ______________ | ____"
    echo "Faculty          | ______________ | ______________ | ____"
    echo "Administration   | ______________ | ______________ | ____"
    echo "P2P Link 1       | ______________ | ______________ | ____"
    echo "P2P Link 2       | ______________ | ______________ | ____"
    echo "P2P Link 3       | ______________ | ______________ | ____"
}

lab2_solution() {
    echo ""
    echo "=== Lab 2 Solution ==="
    echo ""
    echo "Department       | Network         | Subnet Mask     | Hosts"
    echo "─────────────────┼─────────────────┼─────────────────┼──────"
    echo "Library          | 172.20.0.0/23   | 255.255.254.0   | 510"
    echo "Classrooms       | 172.20.2.0/24   | 255.255.255.0   | 254"  
    echo "Lab 1            | 172.20.3.0/25   | 255.255.255.128 | 126"
    echo "Lab 2            | 172.20.3.128/26 | 255.255.255.192 | 62"
    echo "Faculty          | 172.20.3.192/27 | 255.255.255.224 | 30"
    echo "Administration   | 172.20.3.224/28 | 255.255.255.240 | 14"
    echo "P2P Link 1       | 172.20.3.240/30 | 255.255.255.252 | 2"
    echo "P2P Link 2       | 172.20.3.244/30 | 255.255.255.252 | 2"
    echo "P2P Link 3       | 172.20.3.248/30 | 255.255.255.252 | 2"
    echo ""
    echo "Total used: 172.20.0.0 - 172.20.3.251"
    echo "Remaining: 172.20.3.252 - 172.20.255.255"
}

lab_vlsm_design
# Uncomment to show solution:
# lab2_solution
```

### <span style="color: #B8860B;">🔬 Lab 3: Network Configuration</span>

**Objective**: Configure subnets on actual interfaces

```bash
#!/bin/bash

lab_network_config() {
    echo "=== Lab 3: Network Interface Configuration ==="
    echo ""
    
    echo "Task: Configure multiple interfaces with different subnets"
    echo ""
    
    echo "Scenario:"
    echo "- eth0: Management network (192.168.1.0/24)"
    echo "- eth1: Production network (10.10.10.0/24)"  
    echo "- eth2: Development network (172.16.1.0/24)"
    echo ""
    
    echo "Configuration Commands:"
    echo ""
    
    # Management network
    echo "# Configure Management Network (eth0)"
    echo "sudo ip addr add 192.168.1.10/24 dev eth0"
    echo "sudo ip link set eth0 up"
    echo ""
    
    # Production network
    echo "# Configure Production Network (eth1)"
    echo "sudo ip addr add 10.10.10.10/24 dev eth1"
    echo "sudo ip link set eth1 up"
    echo ""
    
    # Development network  
    echo "# Configure Development Network (eth2)"
    echo "sudo ip addr add 172.16.1.10/24 dev eth2"
    echo "sudo ip link set eth2 up"
    echo ""
    
    # Routing
    echo "# Add routing between networks"
    echo "sudo ip route add 10.10.10.0/24 via 192.168.1.1"
    echo "sudo ip route add 172.16.1.0/24 via 192.168.1.1"
    echo ""
    
    # Verification
    echo "# Verify configuration"
    echo "ip addr show"
    echo "ip route show"  
    echo "ping -c 2 192.168.1.1"
    echo "ping -c 2 10.10.10.1"
    echo "ping -c 2 172.16.1.1"
}

# Persistent configuration
persistent_network_config() {
    echo ""
    echo "=== Persistent Configuration (Ubuntu/Debian) ==="
    echo ""
    
    cat << 'EOF'
# /etc/netplan/01-lab-network.yaml
network:
  version: 2
  ethernets:
    eth0:
      addresses:
        - 192.168.1.10/24
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
    
    eth1:
      addresses:
        - 10.10.10.10/24
    
    eth2:
      addresses:
        - 172.16.1.10/24

# Apply with: sudo netplan apply
EOF
}

lab_network_config
persistent_network_config
```

---

## ❓ Practice Problems

### <span style="color: #DC143C;">📝 Subnetting Challenges</span>

**Problem Set 1: Basic Calculations**

1. **Given**: 192.168.10.0/24
   **Task**: Create 8 equal subnets
   **Find**: Network addresses, broadcast addresses, host ranges

2. **Given**: 10.50.0.0/16  
   **Task**: Accommodate 4000 hosts per subnet
   **Find**: Appropriate subnet mask and number of possible subnets

3. **Given**: 172.25.100.50/28
   **Task**: Identify network details
   **Find**: Network address, broadcast, first/last host, total hosts

**Problem Set 2: VLSM Scenarios**

4. **Available**: 192.168.0.0/24
   **Requirements**:
   - Dept A: 120 hosts
   - Dept B: 60 hosts  
   - Dept C: 25 hosts
   - Dept D: 10 hosts
   - 2 Point-to-point links
   
   **Task**: Design VLSM solution

5. **Available**: 10.10.0.0/16
   **Requirements**:
   - Subnet 1: 8000 hosts
   - Subnet 2: 4000 hosts
   - Subnet 3: 2000 hosts
   - Subnet 4: 1000 hosts
   
   **Task**: Allocate subnets using VLSM

**Problem Set 3: Real-world Applications**

6. **Scenario**: ISP allocation
   **Given**: 203.0.113.0/24 (public IP range)
   **Task**: Allocate to 4 customers with 50, 25, 12, and 8 hosts respectively

7. **Scenario**: Multi-location company
   **Available**: 172.16.0.0/12
   **Locations**:
   - Headquarters: 2000 users
   - Branch 1: 500 users
   - Branch 2: 200 users  
   - Branch 3: 100 users
   - WAN links: 6 point-to-point connections
   
   **Task**: Design hierarchical addressing scheme

### <span style="color: #228B22;">✅ Solutions</span>

**Solution 1**:
```bash
# 192.168.10.0/24 → 8 subnets
# Need 3 bits (2^3 = 8) → /27
# Block size: 256/8 = 32

Subnet 1: 192.168.10.0/27    (.0-.31)
Subnet 2: 192.168.10.32/27   (.32-.63)
Subnet 3: 192.168.10.64/27   (.64-.95)
Subnet 4: 192.168.10.96/27   (.96-.127)
Subnet 5: 192.168.10.128/27  (.128-.159)
Subnet 6: 192.168.10.160/27  (.160-.191)
Subnet 7: 192.168.10.192/27  (.192-.223)
Subnet 8: 192.168.10.224/27  (.224-.255)
```

**Solution 4 (VLSM)**:
```bash
# 192.168.0.0/24 VLSM Design
# Order by size (largest first):

Dept A (120): 192.168.0.0/25   (126 hosts) - .0 to .127
Dept B (60):  192.168.0.128/26 (62 hosts)  - .128 to .191  
Dept C (25):  192.168.0.192/27 (30 hosts)  - .192 to .223
Dept D (10):  192.168.0.224/28 (14 hosts)  - .224 to .239
P2P Link 1:   192.168.0.240/30 (2 hosts)   - .240 to .243
P2P Link 2:   192.168.0.244/30 (2 hosts)   - .244 to .247

Remaining: 192.168.0.248/29 (6 addresses available)
```

### <span style="color: #4682B4;">🎯 Challenge Exercises</span>

**Advanced Challenge 1: Supernetting**
```
Given four Class C networks:
- 192.168.4.0/24
- 192.168.5.0/24  
- 192.168.6.0/24
- 192.168.7.0/24

Task: Create a single supernet
Solution: 192.168.4.0/22 (covers .4-.7 ranges)
```

**Advanced Challenge 2: IPv6 Subnetting**
```
Given: 2001:db8::/48
Task: Create 16 subnets for different departments

Solution:
2001:db8:0000::/52  (Department 1)
2001:db8:1000::/52  (Department 2)
2001:db8:2000::/52  (Department 3)
...
2001:db8:f000::/52  (Department 16)
```

---

## 🎯 Key Takeaways

### <span style="color: #FF6347;">🧠 Essential Concepts Mastered</span>

1. **IP Addressing**: Binary-decimal conversion, address classes, private vs public
2. **CIDR Notation**: Prefix length, subnet mask calculations
3. **Subnetting**: Network division, host calculation, address allocation
4. **VLSM**: Efficient address utilization, hierarchical design
5. **IPv6 Basics**: Address format, types, configuration

### <span style="color: #32CD32;">🔧 Practical Skills Developed</span>

1. **Subnet Calculations**: Manual and automated methods
2. **Network Design**: VLSM planning, address allocation
3. **Configuration**: Interface setup, routing configuration
4. **Troubleshooting**: Address conflicts, routing issues
5. **Documentation**: Network diagrams, addressing schemes

### <span style="color: #4169E1;">📊 Tools and Commands</span>

```bash
# Essential commands learned
ip addr show/add/del       # Interface management
ip route show/add/del      # Routing table management
ping/ping6                 # Connectivity testing  
nslookup/dig              # DNS resolution
netstat/ss                # Connection monitoring
traceroute/tracert        # Path tracing
nmap                      # Network discovery
```

---

<div align="center">
  <h3 style="color: #2E8B57;">🎉 Excellent Work!</h3>
  <p>You've mastered IP addressing and subnetting fundamentals!</p>
  <p><strong>Next:</strong> <em>03-network-commands.md</em></p>
  <p><em>Ready to explore network diagnostic tools and commands!</em></p>
</div>

---

<div align="center">
  <p><small>Part of the 30 Days DevOps Zero to Intermediate Journey</small></p>
</div>