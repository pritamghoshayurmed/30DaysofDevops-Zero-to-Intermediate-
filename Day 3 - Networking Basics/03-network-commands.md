# 🛠️ Network Commands and Tools

<div align="center">
  <h2 style="color: #2E8B57;">Essential Network Diagnostic and Management Commands</h2>
  <p><em>Master the Command Line for Network Administration</em></p>
</div>

---

## 📋 Table of Contents

- [🐧 Linux Network Commands](#-linux-network-commands)
- [🪟 Windows Network Commands](#-windows-network-commands)
- [🌐 Cross-Platform Tools](#-cross-platform-tools)
- [📊 Network Monitoring Tools](#-network-monitoring-tools)
- [🔧 Advanced Network Utilities](#-advanced-network-utilities)
- [📱 Mobile and Embedded Tools](#-mobile-and-embedded-tools)
- [🧪 Practical Command Combinations](#-practical-command-combinations)
- [📚 Command Reference Quick Guide](#-command-reference-quick-guide)

---

## 🐧 Linux Network Commands

### <span style="color: #FF6347;">🔍 Network Interface Management</span>

#### **`ip` Command (Modern Linux)**

The `ip` command is the modern replacement for many legacy networking commands:

```bash
# Display all network interfaces
ip addr show
ip a                           # Short form
ip addr show eth0             # Specific interface

# Configure IP address
sudo ip addr add 192.168.1.100/24 dev eth0
sudo ip addr del 192.168.1.100/24 dev eth0

# Enable/disable interface
sudo ip link set eth0 up
sudo ip link set eth0 down

# Show interface statistics
ip -s link show
ip -s link show eth0

# Display routing table
ip route show
ip r                          # Short form

# Add/remove routes
sudo ip route add 10.0.0.0/8 via 192.168.1.1
sudo ip route del 10.0.0.0/8 via 192.168.1.1

# Add default gateway
sudo ip route add default via 192.168.1.1

# Show ARP table (neighbor cache)
ip neighbor show
ip neigh                      # Short form

# Add static ARP entry
sudo ip neighbor add 192.168.1.1 lladdr 00:11:22:33:44:55 dev eth0
```

#### **`ifconfig` Command (Legacy but still useful)**

```bash
# Display all interfaces
ifconfig
ifconfig -a                   # Include inactive interfaces

# Display specific interface
ifconfig eth0

# Configure IP address
sudo ifconfig eth0 192.168.1.100 netmask 255.255.255.0

# Enable/disable interface  
sudo ifconfig eth0 up
sudo ifconfig eth0 down

# Configure additional IP (alias)
sudo ifconfig eth0:1 192.168.1.101 netmask 255.255.255.0

# Change MTU size
sudo ifconfig eth0 mtu 1500

# Enable promiscuous mode (packet capture)
sudo ifconfig eth0 promisc
sudo ifconfig eth0 -promisc   # Disable
```

#### **Network Interface Utilities**

```bash
# List network interfaces
ls /sys/class/net/
cat /proc/net/dev

# Check interface driver and details
ethtool eth0                  # Interface settings
ethtool -i eth0              # Driver information  
ethtool -S eth0              # Statistics

# Set interface speed and duplex
sudo ethtool -s eth0 speed 1000 duplex full autoneg off

# Show link status
cat /sys/class/net/eth0/operstate
cat /sys/class/net/eth0/carrier

# Network namespace operations
ip netns list                 # List network namespaces
sudo ip netns add test_ns     # Create namespace
sudo ip netns exec test_ns ip addr show  # Execute in namespace
```

### <span style="color: #4169E1;">🌐 Connectivity Testing</span>

#### **`ping` Command**

```bash
# Basic ping
ping google.com
ping 8.8.8.8

# Ping with options
ping -c 4 google.com          # Send only 4 packets
ping -i 0.2 google.com        # 0.2 second interval
ping -s 1024 google.com       # Packet size 1024 bytes
ping -t 64 google.com         # Set TTL to 64
ping -W 5 google.com          # Wait 5 seconds for response

# Ping specific interface
ping -I eth0 google.com

# Ping IPv6
ping6 google.com
ping -6 google.com

# Flood ping (use carefully!)
sudo ping -f google.com       # Requires root

# Ping with timestamp
ping -D google.com            # Print timestamp

# Practical ping script
ping_monitor() {
    local host=$1
    local count=${2:-10}
    
    echo "=== Ping Monitor for $host ==="
    echo "Timestamp: $(date)"
    echo ""
    
    ping -c $count $host | while read line; do
        echo "$(date '+%Y-%m-%d %H:%M:%S'): $line"
    done
}

ping_monitor "google.com" 5
```

#### **`traceroute` Command**

```bash
# Basic traceroute
traceroute google.com
traceroute -n google.com      # Don't resolve hostnames
traceroute -m 20 google.com   # Max 20 hops

# Use different protocols
traceroute -T google.com      # TCP traceroute
traceroute -U google.com      # UDP traceroute (default)
traceroute -I google.com      # ICMP traceroute

# IPv6 traceroute
traceroute6 google.com

# MTU path discovery
traceroute --mtu google.com

# Traceroute with specific port
traceroute -p 80 google.com

# Advanced traceroute analysis
analyze_route() {
    local destination=$1
    echo "=== Route Analysis to $destination ==="
    
    traceroute -n $destination | awk '
    /^ *[0-9]+/ {
        hop = $1
        ip = $2
        time1 = $3
        time2 = $5
        time3 = $7
        
        if (time1 != "*" && time2 != "*" && time3 != "*") {
            avg_time = (time1 + time2 + time3) / 3
            printf "Hop %2d: %-15s Avg: %6.2f ms\n", hop, ip, avg_time
        } else {
            printf "Hop %2d: %-15s Timeout/Error\n", hop, ip
        }
    }'
}

analyze_route "8.8.8.8"
```

### <span style="color: #32CD32;">🔍 DNS Resolution</span>

#### **`nslookup` Command**

```bash
# Basic DNS lookup
nslookup google.com
nslookup 8.8.8.8              # Reverse lookup

# Query specific record types
nslookup -type=A google.com   # A record (default)
nslookup -type=AAAA google.com # IPv6 record
nslookup -type=MX google.com  # Mail exchange records
nslookup -type=NS google.com  # Name server records
nslookup -type=TXT google.com # Text records
nslookup -type=CNAME www.google.com # Canonical name

# Use specific DNS server
nslookup google.com 8.8.8.8
nslookup google.com 1.1.1.1   # Cloudflare DNS

# Interactive mode
nslookup
> google.com
> set type=MX
> google.com
> exit
```

#### **`dig` Command (More powerful)**

```bash
# Basic dig queries
dig google.com                # A record
dig google.com AAAA          # IPv6 record  
dig google.com MX            # Mail records
dig google.com NS            # Name servers
dig google.com TXT           # Text records

# Short format output
dig +short google.com
dig +short google.com MX

# Reverse DNS lookup
dig -x 8.8.8.8

# Query specific DNS server
dig @8.8.8.8 google.com
dig @1.1.1.1 google.com

# Detailed DNS query
dig +trace google.com         # Show full resolution path
dig +noall +answer google.com # Show only answers

# Multiple record types
dig google.com A AAAA MX

# DNS performance testing
measure_dns_performance() {
    local domain=$1
    local dns_servers=("8.8.8.8" "1.1.1.1" "9.9.9.9" "208.67.222.222")
    
    echo "=== DNS Performance Test for $domain ==="
    
    for server in "${dns_servers[@]}"; do
        echo -n "Testing $server: "
        time=$(dig @$server $domain +noall +stats | grep "Query time:" | awk '{print $4}')
        echo "${time}ms"
    done
}

measure_dns_performance "google.com"
```

#### **`host` Command**

```bash
# Simple DNS lookup
host google.com
host 8.8.8.8                 # Reverse lookup

# Query specific record types
host -t A google.com
host -t MX google.com
host -t NS google.com

# Verbose output
host -v google.com

# Use specific DNS server
host google.com 8.8.8.8
```

### <span style="color: #9370DB;">📡 Network Connections</span>

#### **`netstat` Command**

```bash
# Show all connections
netstat -a                   # All connections
netstat -t                   # TCP connections only
netstat -u                   # UDP connections only
netstat -l                   # Listening ports only

# Show with process information
netstat -p                   # Show PID/process name
netstat -tlnp                # TCP, listening, numeric, with processes

# Show routing table
netstat -r                   # Routing table
netstat -rn                  # Numeric format

# Show interface statistics
netstat -i                   # Interface statistics
netstat -s                   # Protocol statistics

# Useful combinations
netstat -tuln                # All TCP/UDP listening ports (numeric)
netstat -tupln               # Include process information
netstat -an | grep :80       # Find what's using port 80

# Monitor connections continuously
netstat -tc 1                # TCP connections, update every second
```

#### **`ss` Command (Modern replacement for netstat)**

```bash
# Basic socket information
ss                           # Show all sockets
ss -t                        # TCP sockets
ss -u                        # UDP sockets
ss -l                        # Listening sockets

# Detailed information
ss -p                        # Show processes
ss -n                        # Numeric addresses
ss -r                        # Resolve hosts

# Useful combinations
ss -tuln                     # TCP/UDP listening (numeric)
ss -tulpn                    # Include process information
ss -o                        # Show timer information

# Filter by state
ss -t state established      # Established TCP connections
ss -t state listening        # Listening TCP sockets

# Filter by port
ss -tuln sport :80          # Source port 80
ss -tuln dport :80          # Destination port 80

# Show socket memory usage
ss -m

# Advanced filtering
ss -t '( dport :80 or dport :443 )'  # HTTP/HTTPS connections
```

#### **`lsof` Command (List Open Files)**

```bash
# Network-related lsof usage
lsof -i                      # All network connections
lsof -i TCP                  # TCP connections only
lsof -i UDP                  # UDP connections only

# Specific port or service
lsof -i :80                  # Port 80
lsof -i :ssh                 # SSH connections
lsof -i TCP:80-443          # Port range

# Specific host
lsof -i@192.168.1.1         # Connections to specific IP

# Process-specific
lsof -p 1234                 # Files opened by PID 1234
lsof -c ssh                  # Files opened by ssh processes

# User-specific
lsof -u username             # Files opened by user

# Combine options
lsof -u username -i TCP      # TCP connections by specific user
```

### <span style="color: #B8860B;">🔧 Network Configuration Files</span>

#### **Important Network Configuration Locations**

```bash
# Network interface configuration
/etc/network/interfaces      # Debian/Ubuntu (traditional)
/etc/netplan/               # Ubuntu (modern)
/etc/sysconfig/network-scripts/  # CentOS/RHEL

# DNS configuration  
/etc/resolv.conf            # DNS servers
/etc/hosts                  # Static hostname resolution
/etc/nsswitch.conf          # Name service switch

# Routing
/proc/net/route             # Kernel routing table
/etc/iproute2/rt_tables     # Routing table names

# Network services
/etc/services               # Port to service mapping
/etc/protocols              # Protocol definitions

# Example: View network configuration files
echo "=== Current DNS Configuration ==="
cat /etc/resolv.conf

echo -e "\n=== Local Host Entries ==="
cat /etc/hosts

echo -e "\n=== Network Interface Configuration ==="
if [ -d /etc/netplan ]; then
    ls -la /etc/netplan/
    for file in /etc/netplan/*.yaml; do
        if [ -f "$file" ]; then
            echo "--- $file ---"
            cat "$file"
        fi
    done
else
    cat /etc/network/interfaces 2>/dev/null || echo "Traditional config not found"
fi
```

---

## 🪟 Windows Network Commands

### <span style="color: #FF4500;">🔍 Windows Network Basics</span>

#### **`ipconfig` Command**

```cmd
REM Display IP configuration
ipconfig                     REM Basic information
ipconfig /all               REM Detailed information

REM DHCP operations
ipconfig /release           REM Release IP address
ipconfig /renew             REM Renew IP address
ipconfig /release "Local Area Connection"  REM Specific adapter

REM DNS operations
ipconfig /flushdns          REM Clear DNS cache
ipconfig /displaydns        REM Show DNS cache
ipconfig /registerdns       REM Refresh DNS registration

REM Show specific adapter
ipconfig /all | findstr "Ethernet"
```

#### **PowerShell Network Commands**

```powershell
# Display network adapters
Get-NetAdapter
Get-NetAdapter | Where-Object Status -eq "Up"

# IP configuration
Get-NetIPConfiguration
Get-NetIPAddress

# Configure IP address
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress "192.168.1.100" -PrefixLength 24

# Remove IP address
Remove-NetIPAddress -IPAddress "192.168.1.100"

# DNS configuration
Get-DnsClientServerAddress
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "8.8.8.8", "8.8.4.4"

# Routing table
Get-NetRoute
New-NetRoute -DestinationPrefix "10.0.0.0/8" -NextHop "192.168.1.1"

# Network connections
Get-NetTCPConnection
Get-NetUDPEndpoint

# Test connectivity
Test-NetConnection google.com -Port 80
Test-NetConnection -ComputerName google.com -CommonTCPPort HTTP
```

### <span style="color: #4169E1;">🌐 Windows Connectivity Tools</span>

#### **`ping` Command (Windows)**

```cmd
REM Basic ping
ping google.com
ping 8.8.8.8

REM Ping options
ping -t google.com          REM Continuous ping
ping -n 10 google.com       REM Send 10 packets
ping -l 1024 google.com     REM 1024 byte packets
ping -i 128 google.com      REM TTL 128
ping -w 5000 google.com     REM 5 second timeout

REM IPv6 ping
ping -6 google.com

REM Ping with specific source
ping -S 192.168.1.100 google.com
```

#### **`tracert` Command**

```cmd
REM Basic traceroute
tracert google.com
tracert -h 15 google.com    REM Maximum 15 hops
tracert -w 5000 google.com  REM 5 second timeout
tracert -d google.com       REM Don't resolve hostnames

REM IPv6 traceroute
tracert -6 google.com
```

### <span style="color: #32CD32;">📊 Windows Network Monitoring</span>

#### **`netstat` Command (Windows)**

```cmd
REM Show all connections
netstat -a                  REM All connections
netstat -n                  REM Numeric addresses
netstat -b                  REM Show executables (requires admin)
netstat -o                  REM Show process IDs

REM Useful combinations
netstat -ano                REM All, numeric, with PIDs
netstat -an | findstr :80   REM Find port 80 usage

REM Show routing table
netstat -r

REM Show statistics
netstat -s                  REM Protocol statistics
netstat -e                  REM Ethernet statistics
```

#### **PowerShell Network Monitoring**

```powershell
# Monitor network connections
Get-NetTCPConnection | Where-Object State -eq "Established"
Get-NetTCPConnection | Where-Object LocalPort -eq 80

# Network statistics
Get-NetAdapterStatistics
Get-Counter "\Network Interface(*)\Bytes Total/sec"

# Process network usage
Get-Process | Select-Object Name, Id, @{Name="Network";Expression={(Get-NetTCPConnection -OwningProcess $_.Id -ErrorAction SilentlyContinue).Count}}
```

### <span style="color: #9370DB;">🔧 Windows Network Utilities</span>

#### **Additional Windows Commands**

```cmd
REM ARP table
arp -a                      REM Show ARP table
arp -a 192.168.1.1         REM Specific IP
arp -s 192.168.1.1 00-11-22-33-44-55  REM Static entry
arp -d 192.168.1.1         REM Delete entry

REM Route management
route print                 REM Show routing table
route add 10.0.0.0 mask 255.0.0.0 192.168.1.1  REM Add route
route delete 10.0.0.0      REM Delete route

REM Network shares
net view                    REM Show network computers
net view \\computername     REM Show shares on computer
net use                     REM Show mapped drives
net use z: \\server\share   REM Map network drive

REM Windows firewall
netsh advfirewall show allprofiles
netsh advfirewall firewall show rule name=all
netsh advfirewall firewall add rule name="Allow Port 80" dir=in action=allow protocol=TCP localport=80
```

---

## 🌐 Cross-Platform Tools

### <span style="color: #FF1493;">🔍 Network Scanning Tools</span>

#### **`nmap` - Network Mapper**

```bash
# Host discovery
nmap -sP 192.168.1.0/24     # Ping scan (discover hosts)
nmap -sn 192.168.1.0/24     # No port scan, just discovery

# Port scanning
nmap google.com             # Basic scan
nmap -p 80,443 google.com   # Specific ports
nmap -p 1-1000 192.168.1.1  # Port range
nmap -p- google.com         # All ports (1-65535)

# Scan types
nmap -sT google.com         # TCP connect scan
nmap -sS google.com         # SYN stealth scan
nmap -sU google.com         # UDP scan
nmap -sA google.com         # ACK scan

# Service detection
nmap -sV google.com         # Version detection
nmap -sC google.com         # Default scripts
nmap -A google.com          # Aggressive scan (OS, version, scripts)

# Output options
nmap -oN scan_results.txt google.com     # Normal output
nmap -oX scan_results.xml google.com     # XML output
nmap -oG scan_results.gnmap google.com   # Grepable output

# Stealth and timing
nmap -T0 google.com         # Paranoid (very slow)
nmap -T1 google.com         # Sneaky
nmap -T2 google.com         # Polite
nmap -T3 google.com         # Normal (default)
nmap -T4 google.com         # Aggressive
nmap -T5 google.com         # Insane (very fast)

# Practical nmap scripts
#!/bin/bash
network_discovery() {
    local network=$1
    echo "=== Network Discovery: $network ==="
    
    # Discover active hosts
    echo "Discovering active hosts..."
    nmap -sn $network | grep -E "Nmap scan report|MAC Address"
    
    echo -e "\nScanning for common services..."
    # Scan for common services on discovered hosts
    for ip in $(nmap -sn $network | grep "Nmap scan report" | awk '{print $5}'); do
        echo "Scanning $ip..."
        nmap -p 22,23,80,443,3389 $ip | grep -E "open|filtered"
    done
}

network_discovery "192.168.1.0/24"
```

#### **`nc` (Netcat) - Network Swiss Army Knife**

```bash
# Port connectivity testing
nc -zv google.com 80        # Test if port 80 is open
nc -zv google.com 80-90     # Test port range

# Banner grabbing
nc google.com 80            # Connect to HTTP port
# Then type: GET / HTTP/1.1
# And: Host: google.com

# UDP testing
nc -u -zv google.com 53     # Test UDP port

# Create simple server
nc -l 8080                  # Listen on port 8080

# File transfer
# On receiver: nc -l 8080 > received_file.txt
# On sender: nc target_ip 8080 < file_to_send.txt

# Chat server
# Server: nc -l 8080
# Client: nc server_ip 8080

# Port scanning with netcat
port_scan_nc() {
    local host=$1
    local start_port=$2
    local end_port=$3
    
    echo "Scanning $host ports $start_port-$end_port"
    
    for port in $(seq $start_port $end_port); do
        if nc -z -w1 $host $port 2>/dev/null; then
            echo "Port $port is open"
        fi
    done
}

port_scan_nc "google.com" 80 90
```

### <span style="color: #20B2AA;">📡 Packet Capture Tools</span>

#### **`tcpdump` - Command Line Packet Analyzer**

```bash
# Basic packet capture
sudo tcpdump                        # Capture all traffic
sudo tcpdump -i eth0               # Specific interface
sudo tcpdump -c 10                 # Capture 10 packets

# Protocol filters
sudo tcpdump tcp                   # TCP traffic only
sudo tcpdump udp                   # UDP traffic only
sudo tcpdump icmp                  # ICMP traffic only

# Host filters
sudo tcpdump host google.com       # Traffic to/from Google
sudo tcpdump src google.com        # Traffic from Google
sudo tcpdump dst google.com        # Traffic to Google

# Port filters
sudo tcpdump port 80               # HTTP traffic
sudo tcpdump port 443              # HTTPS traffic
sudo tcpdump portrange 80-90       # Port range

# Network filters
sudo tcpdump net 192.168.1.0/24    # Local network traffic

# Advanced filters
sudo tcpdump 'tcp port 80 and (src host 192.168.1.100 or dst host 192.168.1.100)'

# Output options
sudo tcpdump -w capture.pcap       # Write to file
sudo tcpdump -r capture.pcap       # Read from file
sudo tcpdump -v                    # Verbose output
sudo tcpdump -vv                   # More verbose
sudo tcpdump -X                    # Hex and ASCII dump

# Practical tcpdump examples
monitor_http_traffic() {
    echo "Monitoring HTTP traffic..."
    sudo tcpdump -i any -n -s 0 -w http_traffic.pcap \
        'tcp port 80 or tcp port 443' &
    
    local tcpdump_pid=$!
    echo "Packet capture started (PID: $tcpdump_pid)"
    echo "Press Enter to stop..."
    read
    
    sudo kill $tcpdump_pid
    echo "Capture saved to http_traffic.pcap"
}

analyze_network_traffic() {
    local interface=${1:-eth0}
    echo "=== Network Traffic Analysis on $interface ==="
    
    # Capture for 60 seconds
    timeout 60 sudo tcpdump -i $interface -nn -q | \
    awk '{
        protocol = $3
        if (protocol ~ /\./) {
            split(protocol, parts, ".")
            protocol = parts[1]
        }
        count[protocol]++
    }
    END {
        print "Protocol Statistics:"
        for (p in count) {
            printf "%-10s: %d packets\n", p, count[p]
        }
    }'
}
```

#### **`tshark` (Wireshark Command Line)**

```bash
# Basic capture
tshark -i eth0                     # Live capture
tshark -i eth0 -c 100             # Capture 100 packets

# Protocol filtering
tshark -i eth0 -f "tcp port 80"   # Capture filter
tshark -r file.pcap -Y "http"     # Display filter

# Output formats
tshark -T fields -e ip.src -e ip.dst -r file.pcap
tshark -T json -r file.pcap > output.json

# Statistics
tshark -r file.pcap -q -z conv,ip  # IP conversations
tshark -r file.pcap -q -z proto,colinfo  # Protocol hierarchy

# Extract specific data
tshark -r file.pcap -T fields -e http.host -e http.request.uri -Y "http.request"
```

---

## 📊 Network Monitoring Tools

### <span style="color: #4682B4;">📈 Real-time Monitoring</span>

#### **`iftop` - Interface Bandwidth Monitor**

```bash
# Basic usage
sudo iftop                         # Monitor default interface
sudo iftop -i eth0                 # Specific interface

# Options
sudo iftop -n                      # Don't resolve hostnames
sudo iftop -P                      # Show ports
sudo iftop -b                      # Don't show bar graphs

# While running:
# Press 'h' for help
# Press 'n' to toggle hostname resolution
# Press 'p' to toggle port display
# Press 'q' to quit
```

#### **`nethogs` - Process Network Usage**

```bash
# Monitor network usage by process
sudo nethogs                       # Default interface
sudo nethogs eth0                  # Specific interface
sudo nethogs -d 5                  # Update every 5 seconds

# Multiple interfaces
sudo nethogs eth0 wlan0
```

#### **`nload` - Network Load Monitor**

```bash
# Basic network load monitoring
nload                              # Default interface
nload eth0                         # Specific interface
nload -u MB                        # Display in Megabytes

# Multiple interfaces
nload eth0 wlan0

# Options
nload -t 500                       # Update interval 500ms
nload -i 1024                      # Input max scale
nload -o 1024                      # Output max scale
```

#### **`vnstat` - Network Statistics**

```bash
# Install and setup vnstat
sudo apt install vnstat            # Ubuntu/Debian
sudo systemctl enable vnstat       # Enable service

# Basic usage
vnstat                             # Show statistics
vnstat -i eth0                     # Specific interface
vnstat -h                          # Hourly stats
vnstat -d                          # Daily stats
vnstat -m                          # Monthly stats
vnstat -w                          # Weekly stats

# Live monitoring
vnstat -l -i eth0                  # Live mode

# Database management
vnstat --create -i eth0            # Create database for interface
vnstat --delete -i eth0            # Delete database
```

### <span style="color: #CD5C5C;">🔧 System Network Information</span>

#### **Comprehensive Network Status Scripts**

```bash
#!/bin/bash

network_health_check() {
    echo "=== Network Health Check Report ==="
    echo "Generated: $(date)"
    echo ""
    
    # Interface status
    echo "1. Network Interfaces:"
    ip -o link show | awk '{print "  " $2 " - " $9}'
    echo ""
    
    # IP addresses
    echo "2. IP Addresses:"
    ip -4 addr show | grep -E "inet.*scope global" | awk '{print "  " $NF ": " $2}'
    echo ""
    
    # Default gateway
    echo "3. Default Gateway:"
    ip route show default | awk '{print "  " $3 " via " $2}'
    echo ""
    
    # DNS servers
    echo "4. DNS Servers:"
    grep nameserver /etc/resolv.conf | awk '{print "  " $2}'
    echo ""
    
    # Connectivity tests
    echo "5. Connectivity Tests:"
    local test_hosts=("8.8.8.8" "google.com" "cloudflare.com")
    
    for host in "${test_hosts[@]}"; do
        if ping -c 1 -W 3 $host &>/dev/null; then
            echo "  ✓ $host - Reachable"
        else
            echo "  ✗ $host - Unreachable"
        fi
    done
    echo ""
    
    # Port connectivity
    echo "6. Essential Service Ports:"
    local services=("google.com:80:HTTP" "google.com:443:HTTPS" "8.8.8.8:53:DNS")
    
    for service in "${services[@]}"; do
        IFS=':' read -r host port name <<< "$service"
        if nc -z -w3 $host $port 2>/dev/null; then
            echo "  ✓ $name ($host:$port) - Open"
        else
            echo "  ✗ $name ($host:$port) - Closed/Filtered"
        fi
    done
    echo ""
    
    # Network load
    echo "7. Network Interface Statistics:"
    cat /proc/net/dev | grep -v "Inter-|face |bytes" | while read line; do
        interface=$(echo $line | awk '{print $1}' | sed 's/:$//')
        rx_bytes=$(echo $line | awk '{print $2}')
        tx_bytes=$(echo $line | awk '{print $10}')
        
        if [ "$rx_bytes" -gt 0 ] || [ "$tx_bytes" -gt 0 ]; then
            rx_mb=$(echo "scale=2; $rx_bytes/1024/1024" | bc)
            tx_mb=$(echo "scale=2; $tx_bytes/1024/1024" | bc)
            echo "  $interface: RX ${rx_mb}MB, TX ${tx_mb}MB"
        fi
    done
}

# Advanced network diagnostics
network_diagnostics() {
    local target_host=${1:-"8.8.8.8"}
    
    echo "=== Advanced Network Diagnostics to $target_host ==="
    echo ""
    
    # Route analysis
    echo "1. Route Analysis:"
    traceroute -n $target_host 2>/dev/null | head -10 | tail -n +2 | \
    awk '{print "  Hop " $1 ": " $2 " (" $3 " " $4 " " $5 ")"}'
    echo ""
    
    # MTU path discovery
    echo "2. MTU Path Discovery:"
    local mtu_sizes=(1500 1472 1024 512)
    for mtu in "${mtu_sizes[@]}"; do
        if ping -M do -s $mtu -c 1 -W 3 $target_host &>/dev/null; then
            echo "  MTU $mtu: ✓ OK"
        else
            echo "  MTU $mtu: ✗ Fragmentation needed"
        fi
    done
    echo ""
    
    # DNS resolution test
    echo "3. DNS Resolution Test:"
    local dns_servers=("8.8.8.8" "1.1.1.1" "9.9.9.9")
    for dns in "${dns_servers[@]}"; do
        local resolve_time=$(dig @$dns google.com +noall +stats | grep "Query time:" | awk '{print $4}')
        if [ -n "$resolve_time" ]; then
            echo "  $dns: ${resolve_time}ms"
        else
            echo "  $dns: Failed"
        fi
    done
}

# Usage
network_health_check
echo ""
network_diagnostics "google.com"
```

---

## 🔧 Advanced Network Utilities

### <span style="color: #B8860B;">🛠️ Network Testing Tools</span>

#### **`iperf3` - Network Performance Testing**

```bash
# Install iperf3
sudo apt install iperf3            # Ubuntu/Debian
sudo yum install iperf3            # CentOS/RHEL

# Server mode
iperf3 -s                          # Start server (port 5201)
iperf3 -s -p 8080                 # Custom port

# Client mode
iperf3 -c server_ip                # Connect to server
iperf3 -c server_ip -t 30          # Run for 30 seconds
iperf3 -c server_ip -P 4           # 4 parallel streams

# UDP testing
iperf3 -c server_ip -u             # UDP test
iperf3 -c server_ip -u -b 100M     # 100 Mbps bandwidth

# Bidirectional testing
iperf3 -c server_ip -d             # Bidirectional
iperf3 -c server_ip -R             # Reverse (server to client)

# JSON output
iperf3 -c server_ip -J             # JSON format

# Network performance script
network_performance_test() {
    local server=$1
    local duration=${2:-10}
    
    echo "=== Network Performance Test to $server ==="
    
    # TCP test
    echo "TCP Performance Test:"
    iperf3 -c $server -t $duration -f M
    
    echo -e "\nUDP Performance Test:"
    iperf3 -c $server -u -t $duration -b 100M -f M
    
    echo -e "\nParallel Stream Test:"
    iperf3 -c $server -P 4 -t $duration -f M
}
```

#### **`mtr` - My Traceroute (Real-time)**

```bash
# Interactive mode
mtr google.com                     # Real-time traceroute

# Report mode
mtr --report google.com            # Generate report
mtr --report-cycles 10 google.com  # 10 cycles

# No DNS resolution
mtr -n google.com

# TCP mode
mtr --tcp google.com

# UDP mode  
mtr --udp google.com

# Specific port
mtr --tcp --port 80 google.com

# Output formats
mtr --json google.com              # JSON output
mtr --csv google.com               # CSV output
```

#### **`hping3` - Advanced Ping Tool**

```bash
# Install hping3
sudo apt install hping3

# TCP ping
sudo hping3 -S google.com -p 80    # SYN to port 80
sudo hping3 -A google.com -p 80    # ACK to port 80

# UDP ping
sudo hping3 --udp google.com -p 53 # UDP to port 53

# ICMP ping
sudo hping3 -1 google.com          # ICMP ping

# Traceroute mode
sudo hping3 --traceroute google.com

# Flood mode (use carefully)
sudo hping3 --flood google.com

# Custom packet size
sudo hping3 -d 1024 google.com     # 1024 byte packets
```

### <span style="color: #FF6347;">📡 Wireless Network Tools</span>

#### **WiFi Management Commands**

```bash
# WiFi interface management
iwconfig                           # Show wireless interfaces
iwconfig wlan0                     # Specific interface info

# Scan for networks
sudo iwlist wlan0 scan             # Scan for WiFi networks
sudo iwlist wlan0 scan | grep ESSID

# Network Manager (Ubuntu/modern distributions)
nmcli device wifi list            # List available networks
nmcli device wifi connect "NetworkName" password "password"
nmcli connection show              # Show connections
nmcli connection up connection_name

# Connect to WiFi network
sudo iwconfig wlan0 essid "NetworkName"
sudo iwconfig wlan0 key "password"

# Advanced wireless info
sudo iw dev wlan0 info             # Interface information
sudo iw dev wlan0 scan             # Scan for networks
sudo iw dev wlan0 link             # Connection status

# WiFi signal monitoring
watch -n 1 'cat /proc/net/wireless'

# WiFi troubleshooting script
wifi_diagnostics() {
    echo "=== WiFi Diagnostics ==="
    
    # Find wireless interfaces
    local wifi_interfaces=$(iw dev | awk '$1=="Interface"{print $2}')
    
    for interface in $wifi_interfaces; do
        echo "Interface: $interface"
        
        # Interface status
        echo "  Status: $(cat /sys/class/net/$interface/operstate)"
        
        # Connection info
        iw dev $interface link 2>/dev/null && {
            echo "  Connected to: $(iw dev $interface link | grep SSID | awk '{print $2}')"
            echo "  Signal: $(iw dev $interface link | grep signal | awk '{print $2 $3}')"
        } || echo "  Not connected"
        
        echo ""
    done
    
    # Available networks
    echo "Available Networks:"
    nmcli device wifi list | head -10
}
```

---

## 📱 Mobile and Embedded Tools

### <span style="color: #20B2AA;">📲 Android Network Commands</span>

For Android devices with terminal access:

```bash
# Basic network info
ip addr show                       # Interface information
netstat -rn                        # Routing table

# WiFi information
cat /proc/net/wireless            # Wireless statistics
wpa_cli status                    # WiFi connection status

# Mobile network info
cat /sys/class/net/rmnet0/statistics/rx_bytes  # Mobile data usage
```

### <span style="color: #9370DB;">🔧 Embedded Linux Network Tools</span>

For IoT devices and embedded systems:

```bash
# Minimal network check
busybox ifconfig                   # BusyBox version
busybox route                      # Routing table
busybox ping google.com            # Connectivity test

# Network configuration
echo "nameserver 8.8.8.8" > /etc/resolv.conf
ifconfig eth0 192.168.1.100 netmask 255.255.255.0 up
route add default gw 192.168.1.1
```

---

## 🧪 Practical Command Combinations

### <span style="color: #4169E1;">🔗 Network Automation Scripts</span>

#### **Automated Network Discovery**

```bash
#!/bin/bash

comprehensive_network_scan() {
    local network=${1:-"192.168.1.0/24"}
    local output_dir="/tmp/network_scan_$(date +%Y%m%d_%H%M%S)"
    
    mkdir -p "$output_dir"
    echo "=== Comprehensive Network Scan ==="
    echo "Network: $network"
    echo "Output directory: $output_dir"
    echo ""
    
    # Phase 1: Host Discovery
    echo "Phase 1: Discovering active hosts..."
    nmap -sn $network > "$output_dir/hosts.txt"
    local active_hosts=$(grep "Nmap scan report" "$output_dir/hosts.txt" | awk '{print $5}')
    local host_count=$(echo "$active_hosts" | wc -l)
    echo "Found $host_count active hosts"
    
    # Phase 2: Port Scanning
    echo "Phase 2: Scanning common ports..."
    echo "$active_hosts" | while read host; do
        if [ -n "$host" ]; then
            echo "Scanning $host..."
            nmap -p 21,22,23,25,53,80,110,143,443,993,995,3389 "$host" > "$output_dir/ports_$host.txt"
        fi
    done
    
    # Phase 3: Service Detection
    echo "Phase 3: Detecting services..."
    echo "$active_hosts" | while read host; do
        if [ -n "$host" ]; then
            nmap -sV -p 22,80,443 "$host" > "$output_dir/services_$host.txt" 2>/dev/null
        fi
    done
    
    # Phase 4: Generate Report
    echo "Phase 4: Generating report..."
    {
        echo "Network Scan Report - $(date)"
        echo "Network: $network"
        echo ""
        echo "Active Hosts:"
        echo "$active_hosts"
        echo ""
        echo "Open Ports Summary:"
        grep -h "open" "$output_dir"/ports_*.txt | sort | uniq -c | sort -nr
    } > "$output_dir/summary_report.txt"
    
    echo "Scan complete. Report saved in $output_dir"
}

# Usage
comprehensive_network_scan "192.168.1.0/24"
```

#### **Network Connectivity Monitor**

```bash
#!/bin/bash

network_monitor() {
    local log_file="/var/log/network_monitor.log"
    local check_interval=60
    local hosts=("8.8.8.8" "1.1.1.1" "google.com")
    
    echo "Starting network monitoring (logging to $log_file)"
    
    while true; do
        local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        local status_msg="[$timestamp]"
        
        # Test each host
        for host in "${hosts[@]}"; do
            if ping -c 1 -W 3 "$host" &>/dev/null; then
                status_msg="$status_msg $host:OK"
            else
                status_msg="$status_msg $host:FAIL"
            fi
        done
        
        # Check default gateway
        local gateway=$(ip route show default | awk '{print $3}' | head -1)
        if [ -n "$gateway" ] && ping -c 1 -W 2 "$gateway" &>/dev/null; then
            status_msg="$status_msg Gateway:OK"
        else
            status_msg="$status_msg Gateway:FAIL"
        fi
        
        # Log status
        echo "$status_msg" | tee -a "$log_file"
        
        sleep $check_interval
    done
}

# Run in background: network_monitor &
```

#### **Bandwidth Usage Monitor**

```bash
#!/bin/bash

bandwidth_monitor() {
    local interface=${1:-"eth0"}
    local interval=${2:-5}
    local duration=${3:-300}  # 5 minutes
    
    echo "Monitoring bandwidth on $interface for $duration seconds"
    echo "Time,RX_Bytes,TX_Bytes,RX_Rate,TX_Rate"
    
    local start_time=$(date +%s)
    local prev_rx=$(cat /sys/class/net/$interface/statistics/rx_bytes)
    local prev_tx=$(cat /sys/class/net/$interface/statistics/tx_bytes)
    
    while [ $(($(date +%s) - start_time)) -lt $duration ]; do
        sleep $interval
        
        local current_rx=$(cat /sys/class/net/$interface/statistics/rx_bytes)
        local current_tx=$(cat /sys/class/net/$interface/statistics/tx_bytes)
        
        local rx_rate=$(((current_rx - prev_rx) / interval))
        local tx_rate=$(((current_tx - prev_tx) / interval))
        
        local timestamp=$(date '+%H:%M:%S')
        echo "$timestamp,$current_rx,$current_tx,$rx_rate,$tx_rate"
        
        prev_rx=$current_rx
        prev_tx=$current_tx
    done
}

# Convert bytes to human readable format
bytes_to_human() {
    local bytes=$1
    local units=("B" "KB" "MB" "GB" "TB")
    local unit=0
    
    while [ $bytes -gt 1024 ] && [ $unit -lt 4 ]; do
        bytes=$((bytes / 1024))
        unit=$((unit + 1))
    done
    
    echo "$bytes ${units[$unit]}"
}
```

---

## 📚 Command Reference Quick Guide

### <span style="color: #FF4500;">⚡ Essential Commands Cheat Sheet</span>

#### **Network Interface Management**
```bash
# Modern Linux (ip command)
ip addr show                    # Show all interfaces
ip addr add IP/MASK dev IFACE  # Add IP address
ip link set IFACE up/down      # Enable/disable interface
ip route show                  # Show routing table
ip route add NETWORK via GW    # Add route

# Legacy Linux (ifconfig/route)
ifconfig                       # Show interfaces
ifconfig IFACE IP netmask MASK # Configure IP
route -n                       # Show routes
route add -net NETWORK gw GW   # Add route

# Windows
ipconfig /all                  # Show configuration
ipconfig /release              # Release DHCP
ipconfig /renew                # Renew DHCP
```

#### **Connectivity Testing**
```bash
# Basic connectivity
ping HOST                      # Test reachability
ping -c COUNT HOST            # Limited ping
traceroute HOST               # Show path
tracert HOST                  # Windows traceroute

# Advanced testing
nc -zv HOST PORT              # Test TCP port
nc -u -zv HOST PORT           # Test UDP port
telnet HOST PORT              # Interactive connection
```

#### **DNS Resolution**
```bash
# DNS lookup tools
nslookup HOST                 # Basic lookup
dig HOST                      # Detailed lookup
host HOST                     # Simple lookup

# Specific record types
dig HOST MX                   # Mail records
dig HOST NS                   # Name servers
dig HOST TXT                  # Text records
```

#### **Network Monitoring**
```bash
# Connection monitoring
netstat -tuln                 # Show listening ports
ss -tuln                      # Modern alternative
lsof -i                       # Show network files

# Traffic monitoring
tcpdump -i IFACE              # Packet capture
iftop                         # Bandwidth by host
nethogs                       # Usage by process
```

### <span style="color: #32CD32;">📖 Command Parameters Reference</span>

#### **Common `ip` Command Options**
```
addr     - Address management
link     - Interface management
route    - Routing table management
neighbor - ARP table management
-4       - IPv4 only
-6       - IPv6 only
-s       - Show statistics
-o       - One line output
```

#### **Common `ping` Options**
```
-c COUNT - Number of packets
-i INTERVAL - Time between packets
-s SIZE  - Packet size
-t TTL   - Time to live
-W TIMEOUT - Response timeout
-I INTERFACE - Source interface
```

#### **Common `nmap` Options**
```
-sP/-sn  - Ping scan (no port scan)
-sS      - SYN stealth scan
-sT      - TCP connect scan
-sU      - UDP scan
-p PORTS - Port specification
-A       - Aggressive scan
-T0-T5   - Timing template
-oN FILE - Normal output to file
```

---

## 🎯 Key Takeaways

### <span style="color: #FF6347;">🧠 Command Categories Mastered</span>

1. **Interface Management**: `ip`, `ifconfig` - Configure network interfaces
2. **Connectivity Testing**: `ping`, `traceroute` - Test network reachability
3. **DNS Resolution**: `nslookup`, `dig`, `host` - Resolve domain names
4. **Connection Monitoring**: `netstat`, `ss`, `lsof` - Monitor network connections
5. **Packet Analysis**: `tcpdump`, `tshark` - Capture and analyze network traffic
6. **Network Scanning**: `nmap`, `nc` - Discover and test network services
7. **Performance Testing**: `iperf3`, `mtr` - Test network performance
8. **Traffic Monitoring**: `iftop`, `nethogs`, `nload` - Monitor bandwidth usage

### <span style="color: #4169E1;">🔧 Practical Skills Developed</span>

1. **Network Configuration**: Set up interfaces, routing, DNS
2. **Troubleshooting**: Diagnose connectivity issues systematically  
3. **Monitoring**: Track network usage and performance
4. **Security**: Scan networks, analyze traffic, detect issues
5. **Automation**: Create scripts for network tasks
6. **Documentation**: Generate network reports and logs

### <span style="color: #32CD32;">🚀 Next Level Skills</span>

After mastering these commands, you can:
- Automate network monitoring and reporting
- Troubleshoot complex network issues efficiently
- Perform security assessments and audits
- Optimize network performance
- Manage enterprise network infrastructure

---

<div align="center">
  <h3 style="color: #2E8B57;">🎉 Command Line Mastery Achieved!</h3>
  <p>You now have a comprehensive toolkit for network management!</p>
  <p><strong>Next:</strong> <em>04-network-troubleshooting.md</em></p>
  <p><em>Ready to become a network troubleshooting expert!</em></p>
</div>

---

<div align="center">
  <p><small>Part of the 30 Days DevOps Zero to Intermediate Journey</small></p>
</div>