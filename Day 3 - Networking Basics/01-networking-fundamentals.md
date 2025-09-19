# 🌐 Networking Fundamentals

<div align="center">
  <h2 style="color: #2E8B57;">Understanding the Building Blocks of Network Communication</h2>
  <p><em>Master the OSI Model, TCP/IP Stack, and Core Networking Concepts</em></p>
</div>

---

## 📋 Table of Contents

- [🏗️ The OSI Model](#️-the-osi-model)
- [🌍 TCP/IP Protocol Suite](#-tcpip-protocol-suite)
- [🔗 Network Protocols Overview](#-network-protocols-overview)
- [🚪 Ports and Services](#-ports-and-services)
- [🗂️ Network Topologies](#️-network-topologies)
- [📡 Network Devices](#-network-devices)
- [🔐 Basic Network Security](#-basic-network-security)
- [🧪 Practical Examples](#-practical-examples)
- [❓ Knowledge Check](#-knowledge-check)

---

## 🏗️ The OSI Model

The **Open Systems Interconnection (OSI)** model is a conceptual framework that describes how network communication occurs. Think of it as a **7-layer cake** where each layer has a specific function.

### <span style="color: #FF6347;">📚 The 7 Layers Explained</span>

```
┌─────────────────────────────────────────────────────────────┐
│ Layer 7 - Application    │ HTTP, FTP, SMTP, DNS          │
├─────────────────────────────────────────────────────────────┤
│ Layer 6 - Presentation   │ SSL/TLS, Encryption, JPEG     │
├─────────────────────────────────────────────────────────────┤
│ Layer 5 - Session        │ NetBIOS, RPC, SQL Sessions    │
├─────────────────────────────────────────────────────────────┤
│ Layer 4 - Transport      │ TCP, UDP, Port Numbers        │
├─────────────────────────────────────────────────────────────┤
│ Layer 3 - Network        │ IP, ICMP, Routing             │
├─────────────────────────────────────────────────────────────┤
│ Layer 2 - Data Link      │ Ethernet, WiFi, MAC Address  │
├─────────────────────────────────────────────────────────────┤
│ Layer 1 - Physical       │ Cables, Hubs, Electrical     │
└─────────────────────────────────────────────────────────────┘
```

### <span style="color: #4169E1;">🔍 Layer-by-Layer Deep Dive</span>

#### **Layer 1: Physical Layer** 🔌
**Purpose**: Transmission of raw bits over physical medium

**Key Concepts**:
- Electrical signals, light pulses, radio waves
- Cable specifications (Cat5e, Cat6, Fiber)
- Physical connectors (RJ45, USB, etc.)

**Examples**:
```bash
# Check physical network interface status
ip link show
# Output shows: state UP/DOWN indicates physical connectivity
```

**Real-world analogy**: The electrical wires and cables in your house

---

#### **Layer 2: Data Link Layer** 🔗
**Purpose**: Node-to-node communication, error detection

**Key Concepts**:
- **MAC (Media Access Control) addresses**: Unique hardware identifiers
- **Frames**: Data units at this layer
- **Switching**: Forwarding frames based on MAC addresses

**MAC Address Format**:
```
Example: 00:1B:44:11:3A:B7
         │  │  │  │  │  │
         └──┴──┴──┴──┴──┴── 48-bit hexadecimal address
```

**Common Commands**:
```bash
# View MAC addresses
ip link show                    # Linux
getmac                         # Windows
arp -a                         # View ARP table (MAC to IP mapping)
```

**Real-world analogy**: Street addresses on houses

---

#### **Layer 3: Network Layer** 🌐
**Purpose**: Routing and logical addressing

**Key Concepts**:
- **IP Addresses**: Logical addresses for devices
- **Routing**: Path selection between networks
- **Subnets**: Logical network divisions

**IP Address Structure**:
```
IPv4: 192.168.1.100/24
      │       │   │  │
      │       │   │  └── Subnet mask (/24 = 255.255.255.0)
      │       │   └───── Host portion
      │       └───────── Network portion
      └───────────────── Private IP range
```

**Routing Example**:
```bash
# View routing table
ip route show                   # Linux
route print                    # Windows

# Add a static route
sudo ip route add 10.0.0.0/8 via 192.168.1.1    # Linux
route add 10.0.0.0 mask 255.0.0.0 192.168.1.1   # Windows
```

**Real-world analogy**: Postal addresses and mail routing

---

#### **Layer 4: Transport Layer** 🚛
**Purpose**: End-to-end communication, reliability

**Key Concepts**:
- **TCP (Transmission Control Protocol)**: Reliable, connection-oriented
- **UDP (User Datagram Protocol)**: Fast, connectionless
- **Port Numbers**: Application identification

**TCP vs UDP Comparison**:
```
┌─────────────┬─────────────────┬─────────────────┐
│   Feature   │      TCP        │      UDP        │
├─────────────┼─────────────────┼─────────────────┤
│ Connection  │ Connection-based│ Connectionless  │
│ Reliability │ Guaranteed      │ Best effort     │
│ Speed       │ Slower          │ Faster          │
│ Use Cases   │ Web, Email, FTP │ Gaming, DNS, TV │
└─────────────┴─────────────────┴─────────────────┘
```

**TCP Three-Way Handshake**:
```
Client                     Server
  │                          │
  │────── SYN ──────────────→│
  │                          │
  │←───── SYN-ACK ───────────│
  │                          │
  │────── ACK ──────────────→│
  │                          │
  │    Connection Established │
```

**Common Commands**:
```bash
# Show active connections
netstat -an                    # All platforms
ss -tuln                      # Modern Linux alternative

# Test TCP connection
telnet google.com 80          # Test if port 80 is open
nc -zv google.com 80          # Linux alternative with netcat
```

**Real-world analogy**: TCP = Registered mail, UDP = Regular mail

---

#### **Layer 5: Session Layer** 📞
**Purpose**: Manages sessions between applications

**Key Concepts**:
- Session establishment, maintenance, termination
- Dialog control (full-duplex, half-duplex)
- Checkpointing and recovery

**Examples**:
- SQL database sessions
- Remote procedure calls (RPC)
- NetBIOS sessions

```bash
# View active sessions (Linux)
who                           # Show logged-in users
w                            # Show what users are doing

# View SMB/CIFS sessions
smbstatus                    # Samba sessions
```

**Real-world analogy**: A phone conversation session

---

#### **Layer 6: Presentation Layer** 🎭
**Purpose**: Data translation, encryption, compression

**Key Concepts**:
- Data format conversion
- Encryption/Decryption
- Compression/Decompression

**Examples**:
- SSL/TLS encryption
- JPEG, GIF, PNG formats
- ASCII, Unicode encoding

```bash
# SSL/TLS connection test
openssl s_client -connect google.com:443

# Check SSL certificate
openssl x509 -in certificate.crt -text -noout

# File compression examples
gzip file.txt                # Compress file
gunzip file.txt.gz          # Decompress file
```

**Real-world analogy**: A translator converting languages

---

#### **Layer 7: Application Layer** 💻
**Purpose**: Network services to end users

**Key Concepts**:
- User interface to network services
- Application protocols
- Network-aware applications

**Common Protocols**:
```bash
# HTTP - Web browsing
curl -I http://example.com

# FTP - File transfer
ftp ftp.example.com

# SSH - Secure shell
ssh user@server.com

# SMTP - Email sending
telnet smtp.gmail.com 587

# DNS - Domain name resolution
nslookup google.com
dig google.com
```

**Real-world analogy**: The applications you use (web browser, email client)

---

### <span style="color: #32CD32;">🧠 OSI Memory Aid</span>

**From bottom to top**: "**P**lease **D**o **N**ot **T**hrow **S**ausage **P**izza **A**way"
- **P**hysical
- **D**ata Link  
- **N**etwork
- **T**ransport
- **S**ession
- **P**resentation
- **A**pplication

---

## 🌍 TCP/IP Protocol Suite

The **TCP/IP model** is a simpler, more practical model used in real networks. It has **4 layers** that map to the OSI model.

### <span style="color: #FF4500;">📊 TCP/IP vs OSI Mapping</span>

```
TCP/IP Model          OSI Model
┌─────────────────┐   ┌─────────────────┐
│   Application   │   │   Application   │ Layer 7
│                 │ = │   Presentation  │ Layer 6
│                 │   │    Session      │ Layer 5
├─────────────────┤   ├─────────────────┤
│    Transport    │ = │    Transport    │ Layer 4
├─────────────────┤   ├─────────────────┤
│    Internet     │ = │     Network     │ Layer 3
├─────────────────┤   ├─────────────────┤
│ Network Access  │   │   Data Link     │ Layer 2
│                 │ = │    Physical     │ Layer 1
└─────────────────┘   └─────────────────┘
```

### <span style="color: #9370DB;">🔧 TCP/IP Layer Functions</span>

#### **1. Network Access Layer**
- Combines OSI Physical and Data Link layers
- Handles hardware addressing and media access
- Examples: Ethernet, Wi-Fi, PPP

```bash
# Configure network interface
sudo ip addr add 192.168.1.100/24 dev eth0    # Linux
netsh interface ip set address "Local Area Connection" static 192.168.1.100 255.255.255.0 192.168.1.1    # Windows
```

#### **2. Internet Layer**
- Equivalent to OSI Network layer
- IP addressing and routing
- Protocols: IP, ICMP, ARP

```bash
# Internet layer protocols in action
ping 8.8.8.8                    # ICMP
traceroute google.com           # IP routing
arp -a                          # ARP (Address Resolution Protocol)
```

#### **3. Transport Layer**
- Same as OSI Transport layer
- End-to-end communication
- Protocols: TCP, UDP

```bash
# View transport layer connections
netstat -an | grep :80          # HTTP connections
netstat -an | grep :443         # HTTPS connections
```

#### **4. Application Layer**
- Combines OSI Session, Presentation, and Application layers
- User applications and services
- Protocols: HTTP, FTP, SMTP, DNS

---

## 🔗 Network Protocols Overview

### <span style="color: #DC143C;">🌐 Internet Protocols</span>

#### **HTTP/HTTPS - Web Traffic**
```bash
# HTTP request example
curl -v http://httpbin.org/get
# -v flag shows detailed request/response headers

# HTTPS with SSL certificate info
curl -vI https://google.com
```

**HTTP Status Codes**:
```
┌─────┬─────────────────────────────────────┐
│ Code│ Meaning                             │
├─────┼─────────────────────────────────────┤
│ 200 │ OK - Request successful             │
│ 301 │ Moved Permanently - Redirect        │
│ 404 │ Not Found - Resource doesn't exist │
│ 500 │ Internal Server Error               │
└─────┴─────────────────────────────────────┘
```

#### **DNS - Domain Name System**
```bash
# Different types of DNS queries
nslookup google.com                    # Basic lookup
dig google.com                         # Detailed information
dig google.com MX                      # Mail exchange records
dig google.com NS                      # Name servers
dig @8.8.8.8 google.com               # Query specific DNS server

# Reverse DNS lookup
dig -x 8.8.8.8                        # Find hostname for IP
```

**DNS Record Types**:
```
┌─────┬──────────────────────────────────────┐
│Type │ Purpose                              │
├─────┼──────────────────────────────────────┤
│ A   │ Maps hostname to IPv4 address       │
│ AAAA│ Maps hostname to IPv6 address       │
│ MX  │ Mail exchange server                │
│ NS  │ Name server for domain              │
│ CNAME│ Canonical name (alias)             │
│ TXT │ Text information                    │
└─────┴──────────────────────────────────────┘
```

#### **FTP - File Transfer Protocol**
```bash
# Connect to FTP server
ftp ftp.example.com
# Commands within FTP session:
# ls          - list files
# get file    - download file
# put file    - upload file
# binary      - set binary mode
# quit        - exit

# Secure alternatives
sftp user@server.com               # SSH File Transfer Protocol
scp file.txt user@server:/path/    # Secure Copy
```

#### **SMTP/POP3/IMAP - Email Protocols**
```bash
# Test SMTP server
telnet smtp.gmail.com 587
# Then type:
# EHLO gmail.com
# STARTTLS

# Test POP3 server
telnet pop.gmail.com 995

# Test IMAP server
telnet imap.gmail.com 993
```

### <span style="color: #228B22;">🔧 System Administration Protocols</span>

#### **SSH - Secure Shell**
```bash
# Basic SSH connection
ssh username@server.com

# SSH with specific port
ssh -p 2222 username@server.com

# SSH with key authentication
ssh -i ~/.ssh/private_key username@server.com

# SSH tunneling (port forwarding)
ssh -L 8080:localhost:80 username@server.com   # Local port forwarding
ssh -R 8080:localhost:80 username@server.com   # Remote port forwarding
```

#### **SNMP - Simple Network Management Protocol**
```bash
# Install SNMP tools
sudo apt install snmp snmp-mibs-downloader    # Linux

# SNMP query examples
snmpwalk -v2c -c public 192.168.1.1 1.3.6.1.2.1.1.5    # Get system name
snmpget -v2c -c public 192.168.1.1 1.3.6.1.2.1.1.1.0   # Get system description
```

#### **DHCP - Dynamic Host Configuration Protocol**
```bash
# Release and renew DHCP lease
sudo dhclient -r eth0              # Release (Linux)
sudo dhclient eth0                 # Renew (Linux)

ipconfig /release                  # Release (Windows)
ipconfig /renew                    # Renew (Windows)

# View DHCP lease information
cat /var/lib/dhcp/dhclient.leases  # Linux
ipconfig /all                      # Windows
```

---

## 🚪 Ports and Services

### <span style="color: #FF1493;">📊 Well-Known Ports (0-1023)</span>

```bash
# View commonly used ports
cat /etc/services | head -20       # Linux/macOS
```

**Essential Port Numbers**:
```
┌──────┬─────────────┬──────────────────────────────┐
│ Port │ Protocol    │ Service                      │
├──────┼─────────────┼──────────────────────────────┤
│  20  │ FTP-DATA    │ File Transfer (Data)         │
│  21  │ FTP         │ File Transfer (Control)      │
│  22  │ SSH         │ Secure Shell                 │
│  23  │ TELNET      │ Telnet                       │
│  25  │ SMTP        │ Simple Mail Transfer         │
│  53  │ DNS         │ Domain Name System           │
│  67  │ DHCP        │ Dynamic Host Config (Server) │
│  68  │ DHCP        │ Dynamic Host Config (Client) │
│  80  │ HTTP        │ World Wide Web               │
│ 110  │ POP3        │ Post Office Protocol v3      │
│ 143  │ IMAP        │ Internet Message Access      │
│ 443  │ HTTPS       │ HTTP over SSL/TLS            │
│ 993  │ IMAPS       │ IMAP over SSL                │
│ 995  │ POP3S       │ POP3 over SSL                │
└──────┴─────────────┴──────────────────────────────┘
```

### <span style="color: #20B2AA;">🔍 Port Scanning and Discovery</span>

```bash
# Check if a specific port is open
nc -zv google.com 80               # Netcat port check
telnet google.com 80              # Telnet connection test

# Scan multiple ports
nmap -p 80,443,22 google.com      # Scan specific ports
nmap -p 1-1000 192.168.1.1        # Scan port range
nmap -sS 192.168.1.0/24           # SYN scan subnet

# Check what's listening on local ports
netstat -tuln                     # All platforms
ss -tuln                          # Modern Linux alternative
lsof -i                          # List open files/network connections
```

### <span style="color: #4682B4;">⚙️ Managing Services and Ports</span>

```bash
# Linux service management
sudo systemctl status ssh         # Check SSH service status
sudo systemctl start apache2      # Start Apache web server
sudo systemctl enable nginx       # Enable Nginx to start at boot

# Check which process is using a port
sudo netstat -tlnp | grep :80     # Check what's using port 80
sudo lsof -i :80                  # Alternative method

# Firewall management (Linux - ufw)
sudo ufw allow 22/tcp             # Allow SSH
sudo ufw allow 80,443/tcp         # Allow HTTP and HTTPS
sudo ufw status                   # Check firewall status

# Windows firewall
netsh advfirewall firewall add rule name="Allow Port 80" dir=in action=allow protocol=TCP localport=80
```

---

## 🗂️ Network Topologies

### <span style="color: #B8860B;">🏗️ Physical Topologies</span>

#### **1. Bus Topology**
```
Device A ──┬── Device B ──┬── Device C ──┬── Device D
           │              │              │
        Backbone Cable    │              │
                         │              │
                    Terminator    Terminator
```
- All devices share a single communication line
- **Pros**: Simple, cost-effective
- **Cons**: Single point of failure, performance degradation

#### **2. Star Topology**
```
        Device B
            │
Device A ───┼─── Device C
            │
        Switch/Hub
            │
        Device D
```
- All devices connect to a central hub/switch
- **Pros**: Easy troubleshooting, no single point of failure
- **Cons**: Central device failure affects all

#### **3. Ring Topology**
```
Device A ────── Device B
   │               │
   │               │
Device D ────── Device C
```
- Data travels in one direction around the ring
- **Pros**: Equal access, predictable performance
- **Cons**: Break anywhere affects entire network

#### **4. Mesh Topology**
```
Device A ─────┬───── Device B
   │ ╲        │     ╱    │
   │   ╲      │   ╱      │
   │     ╲    │ ╱        │
Device D ─────┼───── Device C
```
- Every device connects to every other device
- **Pros**: High redundancy, fault tolerance
- **Cons**: Expensive, complex management

### <span style="color: #CD5C5C;">🌐 Network Types by Size</span>

```bash
# Network discovery commands for different network types
# Local Area Network (LAN)
nmap -sP 192.168.1.0/24          # Discover local devices

# Wide Area Network (WAN) - trace route shows hops
traceroute google.com

# Personal Area Network (PAN) - Bluetooth devices
hcitool scan                     # Linux Bluetooth scan
```

**Network Types**:
```
┌─────┬────────────────────────────┬─────────────────┐
│ Type│ Coverage                   │ Example         │
├─────┼────────────────────────────┼─────────────────┤
│ PAN │ Personal Area Network      │ Bluetooth, USB  │
│ LAN │ Local Area Network         │ Home, Office    │
│ MAN │ Metropolitan Area Network  │ City-wide       │
│ WAN │ Wide Area Network          │ Internet, MPLS  │
└─────┴────────────────────────────┴─────────────────┘
```

---

## 📡 Network Devices

### <span style="color: #FF6347;">🔌 Layer 1 Devices (Physical)</span>

#### **Hub**
- Operates at Physical layer
- Simply repeats signals to all ports
- Creates single collision domain

```bash
# Hubs are mostly obsolete, but you might see them in legacy networks
# No configuration commands - purely electrical devices
```

#### **Repeater**
- Amplifies and regenerates signals
- Extends network cable distances

### <span style="color: #4169E1;">🔗 Layer 2 Devices (Data Link)</span>

#### **Switch**
- Operates at Data Link layer
- Learns MAC addresses and creates CAM table
- Each port is separate collision domain

```bash
# View MAC address table on managed switches
# (Commands vary by manufacturer)

# Cisco switch example:
# show mac address-table

# Linux bridge (software switch)
brctl show                       # Show bridge information
ip link show type bridge        # Modern way to show bridges
```

#### **Bridge**
- Connects network segments
- Reduces collision domains
- Learning bridge builds forwarding table

### <span style="color: #32CD32;">🌐 Layer 3 Devices (Network)</span>

#### **Router**
- Operates at Network layer
- Routes packets between different networks
- Maintains routing table

```bash
# View routing table
ip route show                    # Linux
route print                     # Windows
netstat -rn                     # All platforms

# Add static route
sudo ip route add 10.0.0.0/8 via 192.168.1.1    # Linux
route add 10.0.0.0 mask 255.0.0.0 192.168.1.1   # Windows

# Router configuration (varies by vendor)
# Example for Linux as router:
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward  # Enable IP forwarding
```

### <span style="color: #9370DB;">🔒 Multi-Layer Devices</span>

#### **Layer 3 Switch**
- Combines switching and routing functions
- VLAN routing capabilities

#### **Firewall**
- Security device filtering traffic
- Can operate at multiple layers

```bash
# Linux firewall (iptables)
sudo iptables -L                 # List current rules
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT    # Allow SSH

# Modern Linux (nftables)
sudo nft list tables
sudo nft list table ip filter

# UFW (Uncomplicated Firewall)
sudo ufw status
sudo ufw allow ssh
sudo ufw enable
```

#### **Load Balancer**
- Distributes traffic across multiple servers
- Can operate at different layers

---

## 🔐 Basic Network Security

### <span style="color: #DC143C;">🛡️ Security Fundamentals</span>

#### **Network Access Control**
```bash
# MAC address filtering (router/switch level)
# Allow only specific devices to connect

# View connected devices
arp -a                           # Show ARP table
nmap -sP 192.168.1.0/24         # Network discovery

# Change MAC address (Linux)
sudo ip link set dev eth0 down
sudo ip link set dev eth0 address 00:11:22:33:44:55
sudo ip link set dev eth0 up
```

#### **Port Security**
```bash
# Disable unused services
sudo systemctl stop telnet      # Stop insecure Telnet
sudo systemctl disable telnet   # Prevent auto-start

# Check listening services
netstat -tuln | grep LISTEN
ss -tuln

# Secure service configuration
# Edit SSH config for security
sudo nano /etc/ssh/sshd_config
# Key settings:
# PermitRootLogin no
# PasswordAuthentication no
# Port 2222 (change default port)
```

#### **Network Encryption**
```bash
# SSL/TLS testing
openssl s_client -connect google.com:443 -servername google.com

# Generate SSL certificate
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365

# SSH key generation
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
ssh-keygen -t ed25519 -C "your_email@example.com"    # More secure option
```

### <span style="color: #228B22;">🔍 Network Monitoring</span>

```bash
# Traffic monitoring
sudo tcpdump -i eth0                    # Capture all traffic on eth0
sudo tcpdump -i eth0 port 80           # Capture only HTTP traffic
sudo tcpdump -i eth0 host 8.8.8.8      # Capture traffic to/from specific host

# Wireshark command-line
tshark -i eth0 -f "tcp port 80"        # HTTP traffic
tshark -i eth0 -f "icmp"               # ICMP traffic

# Network statistics
netstat -i                             # Interface statistics
iftop                                  # Real-time bandwidth usage
nload                                  # Network load monitor
```

---

## 🧪 Practical Examples

### <span style="color: #FF4500;">🔬 Network Discovery Lab</span>

Let's discover devices on your local network:

```bash
# Step 1: Find your network configuration
ip addr show                           # Linux
ipconfig                              # Windows
ifconfig                              # macOS

# Step 2: Identify your network range
# If your IP is 192.168.1.100/24, your network is 192.168.1.0/24

# Step 3: Discover active devices
nmap -sP 192.168.1.0/24              # Ping scan
nmap -sn 192.168.1.0/24              # Network discovery without port scan

# Step 4: Detailed scan of found devices
nmap -A 192.168.1.1                  # Router scan with OS detection
```

### <span style="color: #4682B4;">🌐 Protocol Analysis Exercise</span>

Capture and analyze different protocols:

```bash
# Terminal 1: Start packet capture
sudo tcpdump -i eth0 -w network_traffic.pcap

# Terminal 2: Generate different traffic types
# HTTP traffic
curl http://httpbin.org/get

# DNS traffic
nslookup google.com

# ICMP traffic
ping -c 4 8.8.8.8

# Terminal 1: Stop capture (Ctrl+C) and analyze
tcpdump -r network_traffic.pcap
tcpdump -r network_traffic.pcap 'tcp port 80'    # Filter HTTP
tcpdump -r network_traffic.pcap 'udp port 53'    # Filter DNS
```

### <span style="color: #20B2AA;">🔧 Network Configuration Practice</span>

Configure a network interface manually:

```bash
# Linux network configuration
# View current configuration
ip addr show eth0

# Configure static IP
sudo ip addr add 192.168.1.200/24 dev eth0
sudo ip route add default via 192.168.1.1

# Configure DNS
echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf

# Test configuration
ping -c 4 8.8.8.8
nslookup google.com

# Persistent configuration (Ubuntu/Debian)
sudo nano /etc/netplan/01-netcfg.yaml
```

Example netplan configuration:
```yaml
network:
  version: 2
  ethernets:
    eth0:
      addresses:
        - 192.168.1.200/24
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
```

```bash
# Apply netplan configuration
sudo netplan apply
```

### <span style="color: #B8860B;">🚀 Service Setup Lab</span>

Set up and test a simple web server:

```bash
# Install web server
sudo apt update
sudo apt install apache2              # Ubuntu/Debian
sudo yum install httpd                 # CentOS/RHEL

# Start and enable service
sudo systemctl start apache2
sudo systemctl enable apache2

# Create simple webpage
echo "<h1>Hello Network World!</h1>" | sudo tee /var/www/html/index.html

# Test locally
curl localhost
curl 127.0.0.1

# Check if accessible from network
# From another machine:
curl http://YOUR_SERVER_IP
```

Configure firewall:
```bash
# Allow HTTP traffic
sudo ufw allow 80/tcp
sudo ufw allow 'Apache'

# Check firewall status
sudo ufw status
```

---

## ❓ Knowledge Check

### <span style="color: #FF1493;">📝 Quick Quiz</span>

**1. OSI Layers**
- Which OSI layer handles MAC addresses?
- At what layer does a router primarily operate?
- What layer do switches operate at?

**2. Protocols**
- What's the difference between TCP and UDP?
- Which protocol is used for email sending?
- What port does HTTPS use by default?

**3. IP Addressing**
- What does CIDR /24 mean?
- Is 192.168.1.100 a public or private IP?
- How many hosts can a /26 subnet accommodate?

### <span style="color: #32CD32;">🛠️ Practical Challenges</span>

**Challenge 1: Network Discovery**
```bash
# Your task: Find all devices on your local network
# Document their IP addresses, MAC addresses, and open ports
# Use commands: nmap, arp, netstat

# Start here:
ip route | grep default     # Find your gateway
# Then scan your network range
```

**Challenge 2: Service Configuration**
```bash
# Your task: Set up an SSH server and connect from another machine
# Requirements:
# - Install SSH server
# - Configure for key-based authentication
# - Change default port
# - Test connection

# Steps:
sudo apt install openssh-server
sudo systemctl enable ssh
# Edit /etc/ssh/sshd_config
# Generate and copy SSH keys
```

**Challenge 3: Traffic Analysis**
```bash
# Your task: Capture and analyze web traffic
# Requirements:
# - Use tcpdump to capture HTTP traffic
# - Visit different websites
# - Analyze the captured packets
# - Identify different protocols in the traffic

# Start here:
sudo tcpdump -i eth0 -w web_traffic.pcap 'port 80 or port 443'
```

### <span style="color: #9370DB;">📊 Self-Assessment</span>

Rate your understanding (1-5):
- [ ] OSI Model layers and functions
- [ ] TCP/IP protocol suite
- [ ] Common network protocols
- [ ] IP addressing and subnetting concepts
- [ ] Network devices and their functions
- [ ] Basic network security principles
- [ ] Using network diagnostic tools
- [ ] Configuring network interfaces

**Score Interpretation**:
- 32-40: Excellent understanding
- 24-31: Good grasp, minor gaps
- 16-23: Basic understanding, needs practice
- Below 16: Review materials and practice more

---

## 🎯 Key Takeaways

### <span style="color: #FF6347;">🧠 Essential Concepts to Remember</span>

1. **OSI Model**: 7 layers from Physical to Application
2. **TCP/IP**: 4-layer practical model used in real networks
3. **Protocols**: Each serves specific purposes (HTTP, DNS, SSH, etc.)
4. **IP Addressing**: Logical addressing for network communication
5. **Ports**: Application identification numbers
6. **Network Devices**: Switches, routers, firewalls operate at different layers

### <span style="color: #4169E1;">🔧 Practical Skills Developed</span>

1. **Network Discovery**: Finding and identifying network devices
2. **Protocol Analysis**: Understanding network traffic
3. **Configuration**: Setting up network interfaces and services
4. **Troubleshooting**: Diagnosing network connectivity issues
5. **Security**: Implementing basic network security measures

### <span style="color: #32CD32;">🚀 Next Steps</span>

After mastering these fundamentals:
1. Practice IP addressing and subnetting (next module)
2. Learn advanced network commands and tools
3. Study network troubleshooting methodologies
4. Explore network security in depth
5. Understand cloud networking concepts

---

<div align="center">
  <h3 style="color: #2E8B57;">🎉 Congratulations!</h3>
  <p>You've completed the Networking Fundamentals module!</p>
  <p><strong>Next:</strong> <em>02-ip-addressing-subnetting.md</em></p>
</div>

---

<div align="center">
  <p><small>Part of the 30 Days DevOps Zero to Intermediate Journey</small></p>
</div>