# 🔎 Network Troubleshooting Guide

<div align="center">
  <h2 style="color: #2E8B57;">Systematic Approach to Network Diagnostics</h2>
  <p><em>From Basic Connectivity Issues to Complex Network Problems</em></p>
</div>

---

## 📋 Table of Contents

- [🔍 Network Troubleshooting Methodology](#-network-troubleshooting-methodology)
- [⚡ Common Network Issues](#-common-network-issues)
- [🌐 Layer-by-Layer Diagnostic Approach](#-layer-by-layer-diagnostic-approach)
- [📊 Network Analysis Tools](#-network-analysis-tools)
- [🏢 Enterprise Network Troubleshooting](#-enterprise-network-troubleshooting)
- [☁️ Cloud Network Troubleshooting](#️-cloud-network-troubleshooting)
- [📱 Wireless Network Troubleshooting](#-wireless-network-troubleshooting)
- [🧪 Case Studies & Scenarios](#-case-studies--scenarios)

---

## 🔍 Network Troubleshooting Methodology

### <span style="color: #FF6347;">🎯 The Systematic Approach</span>

Effective network troubleshooting follows a methodical process:

1. **Identify and Isolate the Problem**
2. **Gather Information**
3. **Analyze Data and Consider Possible Causes**
4. **Create Action Plan**
5. **Implement Solution**
6. **Test and Verify**
7. **Document the Solution**

### <span style="color: #4169E1;">📝 Problem Identification Framework</span>

When identifying network issues, ask these key questions:

```
1. What is the exact issue being reported?
2. When did the issue start?
3. Who is experiencing the issue? (specific users, groups, or everyone?)
4. What systems or services are affected?
5. What changed recently? (updates, configurations, physical changes)
6. Is the issue intermittent or constant?
7. Can the issue be reproduced consistently?
```

**Issue Documentation Template**:
```bash
#!/bin/bash

document_network_issue() {
    echo "=== Network Issue Documentation ==="
    echo "Date: $(date)"
    echo ""
    
    # Collect issue details
    read -p "Issue description: " issue_desc
    read -p "When did the issue start? " issue_start
    read -p "Who is affected? " affected_users
    read -p "Systems affected: " affected_systems
    read -p "Recent changes: " recent_changes
    read -p "Issue frequency (constant/intermittent): " issue_freq
    
    # Collect current network state
    echo ""
    echo "Current network state:"
    
    # IP configuration
    echo "=== IP Configuration ==="
    ip addr show
    
    # Default routes
    echo ""
    echo "=== Routing Table ==="
    ip route show
    
    # DNS configuration
    echo ""
    echo "=== DNS Configuration ==="
    cat /etc/resolv.conf
    
    # Save to file
    echo "Saving documentation to network_issue_$(date +%Y%m%d_%H%M%S).log"
    {
        echo "=== Network Issue Documentation ==="
        echo "Date: $(date)"
        echo ""
        echo "Issue description: $issue_desc"
        echo "Issue start: $issue_start"
        echo "Affected users: $affected_users"
        echo "Affected systems: $affected_systems"
        echo "Recent changes: $recent_changes"
        echo "Issue frequency: $issue_freq"
        echo ""
        echo "=== Network State ==="
        echo "IP Configuration:"
        ip addr show
        echo ""
        echo "Routing Table:"
        ip route show
        echo ""
        echo "DNS Configuration:"
        cat /etc/resolv.conf
    } > "network_issue_$(date +%Y%m%d_%H%M%S).log"
}
```

### <span style="color: #32CD32;">🔄 The Divide and Conquer Method</span>

The divide and conquer approach helps isolate complex issues:

1. **Split the problem space**: Divide the network path into segments
2. **Test each segment**: Check one segment at a time
3. **Narrow down**: Identify which segment contains the issue
4. **Solve the specific problem**: Fix the isolated issue

**Example**: Troubleshooting a web connectivity issue:
```
Client ➤ Local Network ➤ Router ➤ ISP ➤ Internet ➤ Web Server

Test points:
1. Local network connectivity (ping local gateway)
2. Internet connectivity (ping 8.8.8.8)
3. DNS resolution (nslookup website.com)
4. Web server connectivity (telnet website.com 80)
5. Application layer (curl website.com)
```

---

## ⚡ Common Network Issues

### <span style="color: #DC143C;">🚫 Connectivity Issues</span>

#### **1. No Network Connectivity**

**Symptoms**: Cannot access any network resources, "Network Unreachable" errors

**Common Causes**:
- Physical cable disconnection
- Network interface disabled
- Incorrect IP configuration
- Faulty network hardware

**Diagnostic Steps**:
```bash
# Check interface status
ip link show                  # Look for "UP" or "DOWN" state
ethtool eth0                  # Check physical link status

# Check IP configuration
ip addr show                  # Verify IP address is assigned
ip route show                 # Check default route exists

# Test local hardware
sudo ethtool -t eth0          # Run interface self-test
sudo mii-tool eth0           # Check link negotiation

# Test local loopback
ping -c 4 127.0.0.1          # Verify TCP/IP stack is functioning
```

**Common Solutions**:
```bash
# Enable interface
sudo ip link set eth0 up

# Configure IP address (static)
sudo ip addr add 192.168.1.100/24 dev eth0
sudo ip route add default via 192.168.1.1

# Or configure via DHCP
sudo dhclient eth0

# On Windows:
ipconfig /release
ipconfig /renew
```

#### **2. Limited Connectivity**

**Symptoms**: Can connect to local network but not the internet

**Common Causes**:
- Default gateway misconfiguration
- DNS resolution issues
- Firewall blocking traffic
- ISP connectivity issues

**Diagnostic Steps**:
```bash
# Test default gateway connectivity
ping -c 4 $(ip route | grep default | awk '{print $3}')

# Test internet connectivity
ping -c 4 8.8.8.8            # Test IP connectivity
ping -c 4 google.com         # Test DNS resolution

# Check DNS configuration
cat /etc/resolv.conf         # View DNS servers
nslookup google.com          # Test name resolution

# Check routing
traceroute 8.8.8.8           # Identify where traffic stops
```

**Common Solutions**:
```bash
# Fix default gateway
sudo ip route replace default via 192.168.1.1

# Update DNS configuration
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf

# Check firewall rules
sudo iptables -L             # View iptables rules
sudo ufw status              # Ubuntu firewall status
```

### <span style="color: #FF4500;">🐢 Performance Issues</span>

#### **1. Slow Network Performance**

**Symptoms**: High latency, slow downloads/uploads, laggy connections

**Common Causes**:
- Network congestion
- Bandwidth limitations
- Hardware bottlenecks
- Resource-intensive applications

**Diagnostic Steps**:
```bash
# Check network load
iftop                        # Real-time bandwidth usage
nload eth0                   # Interface bandwidth monitor
netstat -s                   # Network statistics

# Measure latency
ping -c 10 google.com        # Look for high/variable times

# Bandwidth testing
iperf3 -c iperf.example.com  # Test maximum throughput

# Check for excessive traffic
sudo tcpdump -i eth0 -n      # Identify unusual traffic
nethogs                      # Identify processes using bandwidth
```

**Common Solutions**:
```bash
# Optimize MTU size
sudo ip link set eth0 mtu 1492  # Try different MTU values

# QoS implementation
sudo tc qdisc add dev eth0 root handle 1: htb default 10
sudo tc class add dev eth0 parent 1: classid 1:10 htb rate 5mbit

# Hardware upgrades
# - Upgrade network cables (CAT5e to CAT6)
# - Upgrade network interfaces
# - Upgrade router/switch hardware
```

#### **2. Intermittent Connectivity**

**Symptoms**: Connections drop randomly, periodic outages

**Common Causes**:
- Faulty cables or connections
- Wireless interference
- Hardware overheating
- Duplex mismatch
- Power issues

**Diagnostic Steps**:
```bash
# Monitor connection stability
ping -c 100 8.8.8.8          # Look for packet loss
mtr google.com               # Identify unstable hops

# Check interface errors
ip -s link show eth0         # Look for TX/RX errors
ethtool -S eth0              # Detailed interface statistics

# Check for duplex mismatch
ethtool eth0 | grep -E "Speed|Duplex"

# Monitor system logs
dmesg | grep -i eth0         # Kernel messages about interface
tail -f /var/log/syslog      # Real-time system logs
```

**Common Solutions**:
```bash
# Fix duplex mismatch
sudo ethtool -s eth0 speed 100 duplex full autoneg off

# Replace physical components
# - Try different cables
# - Test different switch ports
# - Check power sources

# Reduce wireless interference
# - Change WiFi channel
# - Move wireless devices
# - Reduce microwave/bluetooth device usage
```

### <span style="color: #9370DB;">📶 DNS Issues</span>

#### **DNS Resolution Failures**

**Symptoms**: Cannot access websites by name but can by IP address

**Common Causes**:
- Misconfigured DNS servers
- DNS server outage
- Local resolver cache issues
- DNS hijacking or poisoning

**Diagnostic Steps**:
```bash
# Test DNS resolution
nslookup google.com          # Basic DNS lookup
nslookup google.com 8.8.8.8  # Test specific DNS server
dig google.com               # Detailed DNS information

# Check DNS configuration
cat /etc/resolv.conf         # Current DNS servers
systemd-resolve --status     # For systemd-based systems

# Test multiple DNS servers
dig @1.1.1.1 google.com      # Test Cloudflare DNS
dig @8.8.8.8 google.com      # Test Google DNS
dig @9.9.9.9 google.com      # Test Quad9 DNS
```

**Common Solutions**:
```bash
# Update DNS servers
echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf
echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf

# Flush DNS cache
sudo systemd-resolve --flush-caches  # systemd-based
sudo service nscd restart           # nscd cache
ipconfig /flushdns                  # Windows

# Create local DNS entries
echo "192.168.1.10 server.local" | sudo tee -a /etc/hosts
```

---

## 🌐 Layer-by-Layer Diagnostic Approach

### <span style="color: #B8860B;">🧩 The OSI Model Approach to Troubleshooting</span>

Troubleshooting network issues using the OSI model, from bottom to top:

#### **Layer 1 (Physical) Issues**

**Key Questions**:
- Are cables properly connected?
- Is hardware powered on?
- Are interface lights showing activity?
- Are there signs of physical damage?

**Diagnostic Commands**:
```bash
# Check interface status
ip link show eth0            # Interface UP/DOWN status
ethtool eth0                 # Link status and speed

# Check physical errors
ethtool -S eth0 | grep error  # Physical error counters
dmesg | grep eth0            # Kernel messages about interface

# Check connectivity at physical layer
sudo mii-tool -v eth0        # Media-independent interface status
```

**Common Fixes**:
- Reseat cables
- Replace damaged cables
- Try different ports
- Replace faulty hardware

#### **Layer 2 (Data Link) Issues**

**Key Questions**:
- Is the MAC address correctly configured?
- Are there MAC address conflicts?
- Are there switching/bridging problems?
- Are VLANs properly configured?

**Diagnostic Commands**:
```bash
# Check MAC address
ip link show eth0            # View interface MAC address
arp -a                       # Check ARP table

# Check for duplicate MAC addresses
arping -D -I eth0 192.168.1.100  # Detect duplicate IPs/MACs

# Check switch configuration (if access available)
# show mac address-table     # Cisco switch command
# show vlan brief            # VLAN information
```

**Common Fixes**:
```bash
# Set custom MAC address (if needed)
sudo ip link set dev eth0 address 00:11:22:33:44:55

# Clear ARP cache
sudo ip neigh flush dev eth0

# Set proper VLAN configuration
sudo ip link add link eth0 name eth0.10 type vlan id 10
```

#### **Layer 3 (Network) Issues**

**Key Questions**:
- Is the IP address configuration correct?
- Is the subnet mask appropriate?
- Is the default gateway reachable?
- Are routing tables correct?

**Diagnostic Commands**:
```bash
# Check IP configuration
ip addr show                 # View IP addresses
ip route show                # View routing table

# Test routing
traceroute 8.8.8.8          # Trace route path
mtr 8.8.8.8                 # More detailed path analysis

# Check for IP conflicts
arping -D -I eth0 192.168.1.100  # Detect IP conflicts
```

**Common Fixes**:
```bash
# Fix IP configuration
sudo ip addr add 192.168.1.100/24 dev eth0
sudo ip route add default via 192.168.1.1

# Add specific routes
sudo ip route add 10.0.0.0/8 via 192.168.1.254

# Enable IP forwarding (for routers)
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
```

#### **Layer 4 (Transport) Issues**

**Key Questions**:
- Are the required ports open?
- Is there a firewall blocking traffic?
- Are there connection limits or timeouts?
- Is the service listening on expected ports?

**Diagnostic Commands**:
```bash
# Check open ports
ss -tuln                     # List listening ports
netstat -tuln                # Alternative command
lsof -i :80                  # What's using port 80

# Test port connectivity
nc -zv google.com 80         # Check if port is open
telnet google.com 80         # Interactive port check

# Check firewall settings
sudo iptables -L             # List firewall rules
sudo nft list ruleset        # For nftables
```

**Common Fixes**:
```bash
# Allow traffic through firewall
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo ufw allow 80/tcp        # Ubuntu firewall

# Check service configuration
sudo systemctl restart nginx  # Restart service
sudo lsof -i :80             # Confirm it's listening

# Fix connection tracking issues
echo 65536 | sudo tee /proc/sys/net/netfilter/nf_conntrack_max
```

#### **Upper Layers (5-7) Issues**

**Key Questions**:
- Are application protocols functioning correctly?
- Is TLS/SSL configured properly?
- Are there authentication issues?
- Is the application returning proper responses?

**Diagnostic Commands**:
```bash
# Test HTTP connectivity
curl -v http://website.com   # Verbose HTTP request
wget -S http://website.com   # Show response headers

# Test HTTPS issues
openssl s_client -connect website.com:443  # Test SSL/TLS
curl -vk https://website.com  # Test HTTPS (ignore cert errors)

# Test DNS application layer
dig +trace google.com        # Full DNS resolution trace
```

**Common Fixes**:
```bash
# Update TLS certificates
sudo openssl x509 -in cert.pem -text -noout  # Check certificate
sudo openssl s_client -connect localhost:443  # Test local HTTPS

# Check application logs
sudo tail -f /var/log/apache2/error.log  # Web server errors
sudo tail -f /var/log/nginx/error.log   # Nginx errors
```

### <span style="color: #20B2AA;">🔄 The End-to-End Path Analysis</span>

Tracing the full path from client to server to identify issues:

```bash
#!/bin/bash

end_to_end_analysis() {
    local target=${1:-"www.google.com"}
    local target_port=${2:-"443"}
    
    echo "=== End-to-End Path Analysis to $target ==="
    echo ""
    
    # Step 1: Local network interface check
    echo "1. Local Interface Status:"
    ip -br link show | grep -v "UNKNOWN"
    echo ""
    
    # Step 2: Local IP configuration
    echo "2. IP Configuration:"
    ip -br addr show | grep -v "scope host lo"
    echo ""
    
    # Step 3: Default gateway check
    echo "3. Default Gateway:"
    local gateway=$(ip route show default | awk '{print $3}')
    echo "Gateway: $gateway"
    
    if ping -c 1 -W 2 $gateway &>/dev/null; then
        echo "Gateway is reachable ✓"
    else
        echo "Gateway is unreachable ✗"
        echo "Local network issue detected - check router/switch"
    fi
    echo ""
    
    # Step 4: DNS resolution
    echo "4. DNS Resolution:"
    echo "Resolving $target..."
    local target_ip=$(dig +short $target | head -1)
    
    if [ -n "$target_ip" ]; then
        echo "Resolved to $target_ip ✓"
    else
        echo "DNS resolution failed ✗"
        echo "DNS issue detected - check DNS configuration"
    fi
    echo ""
    
    # Step 5: Route path analysis
    echo "5. Network Path:"
    echo "Analyzing path to $target ($target_ip)..."
    traceroute -n $target | head -15
    echo ""
    
    # Step 6: Port connectivity
    echo "6. Port Connectivity:"
    echo "Testing connection to $target:$target_port..."
    if nc -z -w3 $target $target_port 2>/dev/null; then
        echo "Port $target_port is open ✓"
    else
        echo "Port $target_port is closed/filtered ✗"
        echo "Possible firewall issue or service not running"
    fi
    echo ""
    
    # Step 7: Application layer test
    echo "7. Application Response:"
    if [[ $target_port -eq 80 ]]; then
        echo "Testing HTTP response..."
        curl -s -o /dev/null -w "Status code: %{http_code}\n" http://$target
    elif [[ $target_port -eq 443 ]]; then
        echo "Testing HTTPS response..."
        curl -s -o /dev/null -w "Status code: %{http_code}\n" https://$target
    else
        echo "Custom port - skipping application test"
    fi
}

end_to_end_analysis "www.google.com" 443
```

---

## 📊 Network Analysis Tools

### <span style="color: #FF1493;">🔍 Packet Capture and Analysis</span>

#### **Using `tcpdump` for Network Diagnostics**

```bash
# Basic packet capture
sudo tcpdump -i eth0 -n     # Capture on interface eth0
sudo tcpdump -i any -n      # Capture on all interfaces

# Filter by host
sudo tcpdump host 192.168.1.100
sudo tcpdump src 192.168.1.100  # Source only
sudo tcpdump dst 192.168.1.100  # Destination only

# Filter by protocol
sudo tcpdump tcp             # TCP only
sudo tcpdump udp             # UDP only
sudo tcpdump icmp            # ICMP only

# Filter by port
sudo tcpdump port 80         # HTTP traffic
sudo tcpdump port 443        # HTTPS traffic
sudo tcpdump port not 22     # Everything except SSH

# Advanced filters
sudo tcpdump 'tcp[tcpflags] & (tcp-syn) != 0'  # SYN packets
sudo tcpdump 'tcp[tcpflags] & (tcp-rst) != 0'  # RST packets
sudo tcpdump 'icmp[icmptype] == 8'             # ICMP Echo requests

# Common issue detection filters
# Detect SYN floods
sudo tcpdump 'tcp[tcpflags] == tcp-syn' -n | wc -l

# Detect DNS issues
sudo tcpdump -n port 53

# Detect ARP spoofing
sudo tcpdump -n arp
```

#### **Using `Wireshark` (Terminal Mode with `tshark`)**

```bash
# Basic capture
tshark -i eth0               # Capture on interface
tshark -i eth0 -c 100        # Capture 100 packets

# Apply filters
tshark -i eth0 -f "host 192.168.1.100"  # Host filter
tshark -i eth0 -f "tcp port 80"        # Port filter

# Analyze existing capture files
tshark -r capture.pcap
tshark -r capture.pcap -Y "http"  # Display filter

# Extract specific fields
tshark -r capture.pcap -T fields -e ip.src -e ip.dst

# Protocol statistics
tshark -r capture.pcap -q -z io,phs  # Protocol hierarchy
tshark -r capture.pcap -q -z conv,ip  # IP conversations
```

### <span style="color: #4682B4;">📊 Network Flow Analysis</span>

#### **Using `netflow` and Similar Tools**

```bash
# Install netflow tools
sudo apt install nfdump     # For Debian/Ubuntu

# Analyze flows
nfdump -R /var/cache/nfdump/flows  # Read flow data
nfdump -R /var/cache/nfdump/flows -s ip/bytes  # Top IPs by bandwidth

# Filter flows
nfdump -R /var/cache/nfdump/flows 'src ip 192.168.1.100'
nfdump -R /var/cache/nfdump/flows 'dst port 80'
```

#### **Using `iftop` for Real-time Bandwidth Analysis**

```bash
# Monitor bandwidth usage
sudo iftop                   # Default interface
sudo iftop -i eth0           # Specific interface
sudo iftop -n               # No DNS resolution
sudo iftop -P               # Show ports

# Filter traffic
sudo iftop -f 'host 192.168.1.100'  # Filter by host
sudo iftop -f 'port 80'            # Filter by port
```

---

## 🏢 Enterprise Network Troubleshooting

### <span style="color: #CD5C5C;">🔒 VLAN and Routing Issues</span>

#### **Common VLAN Problems**

**Symptoms**: Isolated network segments, inability to reach certain networks

**Diagnostic Steps**:
```bash
# Check VLAN configuration
ip -d link show              # Detailed interface info with VLAN
bridge vlan show             # Show VLAN info on bridges

# Check VLAN interfaces
ip addr show | grep "@"      # List VLAN subinterfaces

# Check trunk port config (switch)
# show interfaces trunk      # Cisco command
```

**Common Fixes**:
```bash
# Create VLAN interface
sudo ip link add link eth0 name eth0.10 type vlan id 10
sudo ip link set dev eth0.10 up

# Add IP address to VLAN
sudo ip addr add 10.10.10.1/24 dev eth0.10

# Enable VLAN forwarding
sudo sysctl -w net.ipv4.conf.all.forwarding=1
```

#### **Inter-VLAN Routing Issues**

**Diagnostic Steps**:
```bash
# Verify routing between VLANs
ip route show                # Check routing table
ping -I eth0.10 10.20.20.1   # Test inter-VLAN connectivity

# Check router-on-a-stick config
sudo tcpdump -i eth0 -vv 'vlan'  # Monitor VLAN tagged traffic

# Verify firewall/ACLs
sudo iptables -L -v | grep VLAN  # Check VLAN-specific rules
```

**Common Fixes**:
```bash
# Add inter-VLAN routes
sudo ip route add 10.20.20.0/24 via 10.10.10.254

# Enable VLAN forwarding
sudo sysctl -w net.ipv4.conf.eth0/10.forwarding=1
```

### <span style="color: #228B22;">📡 WAN and VPN Connectivity</span>

#### **WAN Link Issues**

**Diagnostic Steps**:
```bash
# Check WAN interface
ip addr show ppp0           # PPP interfaces
ip addr show eth1           # External interface

# Check WAN routing
ip route show default        # Default route
traceroute 8.8.8.8          # Path to internet

# Check WAN link quality
ping -c 100 8.8.8.8 | grep loss  # Packet loss
mtr 8.8.8.8 -c 100 -r      # Link quality statistics
```

**Common Fixes**:
```bash
# Restart WAN connection
sudo ifdown ppp0 && sudo ifup ppp0  # Restart PPP
sudo systemctl restart network-manager  # NetworkManager

# Fix MTU issues (common with PPPoE)
sudo ip link set ppp0 mtu 1492
```

#### **VPN Connectivity Issues**

**Diagnostic Steps**:
```bash
# Check VPN interfaces
ip addr show tun0           # OpenVPN interface
ip addr show wg0            # WireGuard interface

# Check VPN routing
ip route show table 220     # VPN specific routing table
sudo wg show                # WireGuard status

# Check connection logs
sudo tail -f /var/log/syslog | grep -i vpn
sudo tail -f /var/log/openvpn.log
```

**Common Fixes**:
```bash
# Restart VPN service
sudo systemctl restart openvpn@client
sudo systemctl restart wg-quick@wg0

# Fix VPN routing issues
sudo ip route add 10.0.0.0/8 dev tun0
sudo ip route add default via 10.8.0.1 table 220
```

---

## ☁️ Cloud Network Troubleshooting

### <span style="color: #FF4500;">🌐 Cloud-specific Network Issues</span>

#### **Virtual Private Cloud (VPC) Issues**

**Common Problems**:
- Subnet routing issues
- Security group/firewall rules
- Network ACL misconfiguration
- VPC peering problems

**Diagnostic Steps**:
```bash
# For AWS (using AWS CLI)
aws ec2 describe-security-groups --group-id sg-123456
aws ec2 describe-network-acls
aws ec2 describe-route-tables

# For GCP (using gcloud)
gcloud compute firewall-rules list
gcloud compute routes list
gcloud compute networks subnets list
```

**Common Fixes**:
```bash
# Update security group (AWS)
aws ec2 authorize-security-group-ingress --group-id sg-123456 --protocol tcp --port 22 --cidr 203.0.113.0/24

# Update firewall rule (GCP)
gcloud compute firewall-rules update allow-ssh --allow tcp:22
```

#### **Container and Kubernetes Networking**

**Common Issues**:
- Pod-to-pod communication failures
- Service discovery issues
- Ingress controller problems
- CNI plugin failures

**Diagnostic Steps**:
```bash
# Check Kubernetes networking
kubectl get nodes -o wide     # Node network info
kubectl get pods -o wide      # Pod network info
kubectl describe service my-service  # Service details

# Test connectivity between pods
kubectl exec -it pod-name -- ping other-pod-ip
kubectl exec -it pod-name -- curl service-name:port

# Check CNI configuration
kubectl describe daemonset -n kube-system calico-node  # Calico example
```

**Common Fixes**:
```bash
# Restart CNI pods
kubectl rollout restart daemonset -n kube-system calico-node

# Fix network policies
kubectl apply -f fixed-network-policy.yaml

# Check kube-proxy status
kubectl get pods -n kube-system | grep kube-proxy
kubectl logs -n kube-system kube-proxy-abc123
```

---

## 📱 Wireless Network Troubleshooting

### <span style="color: #9370DB;">📶 WiFi Connectivity Issues</span>

#### **Common WiFi Problems**

**Symptoms**: Disconnections, slow performance, limited range

**Diagnostic Steps**:
```bash
# Check wireless interface
iwconfig wlan0              # Basic wireless information
ip link show wlan0          # Link status

# Scan for networks
sudo iwlist wlan0 scan | grep -E "ESSID|Quality|Channel"

# Check connection quality
watch -n 1 cat /proc/net/wireless  # Real-time signal strength

# Monitor wireless traffic
sudo tcpdump -i wlan0 -n   # Capture wireless packets
```

**Common Fixes**:
```bash
# Reset wireless interface
sudo ip link set wlan0 down
sudo ip link set wlan0 up

# Connect to specific network
sudo iwconfig wlan0 essid "NetworkName" key s:password

# Fix driver issues
sudo modprobe -r iwlwifi    # Remove driver module
sudo modprobe iwlwifi       # Reload driver
```

#### **WiFi Interference and Signal Issues**

**Diagnostic Steps**:
```bash
# Check current channel
iwlist wlan0 channel

# Check signal quality
iwconfig wlan0 | grep "Signal level"

# Scan for overlapping networks
sudo iwlist wlan0 scan | grep -E "Channel|ESSID|Quality"

# Detailed wireless stats
iw dev wlan0 station dump
```

**Common Fixes**:
```bash
# Change WiFi channel (on router)
# Usually through router admin interface

# Improve signal quality
# - Relocate router
# - Remove interference sources
# - Add WiFi repeaters/mesh nodes
```

---

## 🧪 Case Studies & Scenarios

### <span style="color: #4169E1;">📋 Case Study 1: Web Server Connectivity Issue</span>

**Scenario**: Users report inability to access an internal web server.

**Step-by-Step Troubleshooting**:

```bash
# Step 1: Verify local connectivity
ping -c 4 webserver.local     # Test reachability
traceroute webserver.local    # Check path

# Step 2: Test DNS resolution
nslookup webserver.local      # Resolve hostname
host webserver.local          # Alternative DNS lookup

# Step 3: Check port connectivity
nc -zv webserver.local 80     # Test HTTP port
nc -zv webserver.local 443    # Test HTTPS port

# Step 4: Verify web server service
curl -I http://webserver.local  # Check HTTP response
curl -Ik https://webserver.local # Check HTTPS response

# Step 5: Check server-side issues
ssh admin@webserver.local
sudo systemctl status nginx   # Check web server status
sudo tail -f /var/log/nginx/error.log  # Check error logs
```

**Root Cause & Solution**:
The investigation revealed the web server process had crashed. The solution was to restart the service and implement monitoring to catch future crashes early:

```bash
sudo systemctl restart nginx

# Add monitoring check
echo '*/5 * * * * systemctl is-active --quiet nginx || systemctl restart nginx' | sudo crontab -
```

### <span style="color: #FF6347;">📋 Case Study 2: Network Segmentation Problem</span>

**Scenario**: After VLAN reconfiguration, certain departments cannot access shared resources.

**Step-by-Step Troubleshooting**:

```bash
# Step 1: Verify VLAN configuration
ip -d link show             # Check VLAN interfaces
ip addr show | grep @       # List VLAN interfaces

# Step 2: Check routing between VLANs
ip route show table all     # View all routing tables
ip rule show                # Check routing policies

# Step 3: Test inter-VLAN connectivity
ping -I eth0.10 192.168.20.1  # Test from VLAN 10 to VLAN 20

# Step 4: Verify firewall rules
sudo iptables -L FORWARD -v  # Check forwarding rules
sudo iptables -L -t nat     # Check NAT rules

# Step 5: Packet capture on router interface
sudo tcpdump -i eth0 -vv 'vlan 10 or vlan 20'
```

**Root Cause & Solution**:
The issue was caused by missing firewall rules allowing inter-VLAN traffic. The solution was to update firewall rules:

```bash
# Allow traffic between VLANs
sudo iptables -A FORWARD -i eth0.10 -o eth0.20 -j ACCEPT
sudo iptables -A FORWARD -i eth0.20 -o eth0.10 -j ACCEPT

# Save rules permanently
sudo iptables-save | sudo tee /etc/iptables/rules.v4
```

### <span style="color: #32CD32;">📋 Case Study 3: Intermittent Network Outages</span>

**Scenario**: Users report random network disconnections throughout the day.

**Step-by-Step Troubleshooting**:

```bash
# Step 1: Monitor network stability
ping -c 1000 -i 0.5 8.8.8.8 | tee ping_results.txt  # Long-term ping test

# Step 2: Check for interface errors
watch -n 1 "ip -s link show eth0"  # Monitor interface counters

# Step 3: Check system logs for network events
sudo tail -f /var/log/syslog | grep -i eth0

# Step 4: Monitor network load
iftop -i eth0                # Bandwidth utilization
nload eth0                   # Simple load monitor

# Step 5: Set up continuous packet capture
sudo tcpdump -i eth0 -w outage_investigation.pcap 'not port 22'
```

**Root Cause & Solution**:
The investigation revealed faulty network equipment with increasing error rates under load. The solution was hardware replacement:

```bash
# Diagnostic data confirming hardware issue
ethtool -S eth0 | grep -E 'error|drop|collision'

# Hardware replacement steps:
# 1. Replace network switch
# 2. Update network cable to Cat6a
# 3. Implement monitoring for early detection
```

---

## 🎯 Key Takeaways

### <span style="color: #FF6347;">🧠 Troubleshooting Principles</span>

1. **Systematic Approach**: Follow a methodical process for all issues
2. **Isolation**: Divide and conquer to narrow down problem areas
3. **Evidence-Based**: Always gather data before making changes
4. **Layer-by-Layer**: Work through the OSI model methodically
5. **Documentation**: Record all findings and solutions
6. **Verification**: Always test after implementing changes

### <span style="color: #4169E1;">🔧 Essential Troubleshooting Skills</span>

1. **Command Line Mastery**: Proficiency with diagnostic tools
2. **Protocol Knowledge**: Understanding how different protocols function
3. **Systems Thinking**: Seeing how network components interact
4. **Pattern Recognition**: Identifying common failure signatures
5. **Persistence**: Following issues to their root cause

### <span style="color: #32CD32;">🚀 Advanced Troubleshooting Practices</span>

1. **Proactive Monitoring**: Detect issues before users report them
2. **Baseline Knowledge**: Know what "normal" looks like on your network
3. **Documentation**: Maintain network diagrams and configurations
4. **Post-Mortem Analysis**: Learn from past issues to prevent future ones

---

<div align="center">
  <h3 style="color: #2E8B57;">🎉 Network Troubleshooting Mastery Achieved!</h3>
  <p>You now have a systematic approach to diagnose any network issue!</p>
  <p><strong>Next:</strong> <em>05-exercises-and-labs.md</em></p>
  <p><em>Ready to apply your knowledge in practical scenarios!</em></p>
</div>

---

<div align="center">
  <p><small>Part of the 30 Days DevOps Zero to Intermediate Journey</small></p>
</div>