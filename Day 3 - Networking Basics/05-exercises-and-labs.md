# 🚀 Networking Exercises and Labs

<div align="center">
  <h2 style="color: #5F9EA0;">Hands-on Learning for Network Concepts</h2>
  <p><em>Build your networking skills through practical exercises</em></p>
</div>

---

## 📋 Table of Contents

- [🏁 Getting Started](#-getting-started)
- [🔰 Beginner Exercises](#-beginner-exercises)
- [🔄 Intermediate Exercises](#-intermediate-exercises)
- [🔬 Network Simulation Labs](#-network-simulation-labs)
- [🏢 Enterprise Network Labs](#-enterprise-network-labs)
- [🔒 Network Security Challenges](#-network-security-challenges)
- [📝 Lab Solutions & Expected Results](#-lab-solutions--expected-results)
- [📚 Additional Resources](#-additional-resources)

---

## 🏁 Getting Started

### <span style="color: #4682B4;">🛠️ Lab Environment Setup</span>

Before starting the exercises, set up your lab environment. Choose one of the following options:

#### **Option 1: Local Virtualization**

Use virtualization software to create multiple networked virtual machines:

```bash
# Install VirtualBox on Ubuntu
sudo apt update
sudo apt install virtualbox

# Install VirtualBox on CentOS/RHEL
sudo yum install epel-release
sudo yum install VirtualBox

# On Windows, download and install VirtualBox from the official website
# https://www.virtualbox.org/wiki/Downloads
```

#### **Option 2: Cloud-based Lab**

Use cloud providers to set up networking labs:

- AWS: Use VPC, EC2 instances, and Security Groups
- Azure: Use Virtual Networks, VMs, and Network Security Groups
- GCP: Use VPC networks, VM instances, and firewall rules

#### **Option 3: Network Simulators**

Use dedicated network simulation software:

- GNS3: Network simulation platform (https://www.gns3.com/)
- Cisco Packet Tracer: Network simulation tool (for educational purposes)
- EVE-NG: Emulated Virtual Environment for Network, Security

### <span style="color: #FF4500;">📋 Lab Requirements</span>

For most exercises, you'll need:

1. **Two or more Linux VMs** (Ubuntu/CentOS recommended)
2. **Network connectivity** between VMs
3. **Internet access** for package installation
4. **Root/sudo access** for network configuration

```bash
# Quick VM network test (run on each VM)
hostname -I               # Show IP addresses
ip route show            # Show routing table
ping -c 3 <other-vm-ip>  # Test connectivity to other VM
ping -c 3 8.8.8.8        # Test internet connectivity
```

---

## 🔰 Beginner Exercises

### <span style="color: #32CD32;">📡 Exercise 1: Network Discovery and Mapping</span>

#### **Objective**: 
Learn to discover and document network topology and connected devices.

#### **Tasks**:

1. **Discover local network devices**:

```bash
# Install network scanning tools
sudo apt install nmap -y  # For Debian/Ubuntu
sudo yum install nmap -y  # For CentOS/RHEL

# Basic network scan
sudo nmap -sn 192.168.1.0/24  # Replace with your network CIDR

# Save results to a file
sudo nmap -sn 192.168.1.0/24 -oN network_map.txt
```

2. **Identify open ports on devices**:

```bash
# Scan a specific device
sudo nmap -A 192.168.1.1  # Replace with target IP

# Scan specific ports
sudo nmap -p 22,80,443 192.168.1.1
```

3. **Map the network visually**:
   - Create a simple network diagram using a tool like draw.io or Lucidchart
   - Include devices, IP addresses, open ports, and connections

4. **Document your findings**:
   - Create an inventory of devices with their IP addresses
   - List services running on each device
   - Identify potential security issues

#### **Lab Questions**:
1. How many devices are on your network?
2. What services are most commonly exposed?
3. What information could an attacker gain from a network scan?
4. How would you hide services from network scanning?

### <span style="color: #9370DB;">🔄 Exercise 2: IP Addressing and Subnetting Practice</span>

#### **Objective**: 
Gain practical experience with IP addressing, subnetting, and CIDR notation.

#### **Tasks**:

1. **Calculate subnet information**:

Given the network 192.168.10.0/24:

```bash
# Use ipcalc tool
sudo apt install ipcalc -y  # For Debian/Ubuntu
sudo yum install ipcalc -y  # For CentOS/RHEL

# Calculate network information
ipcalc 192.168.10.0/24

# Try different subnet masks
ipcalc 192.168.10.0/25
ipcalc 192.168.10.0/26
```

2. **Create subnets manually**:
   - Divide 192.168.10.0/24 into 4 equal subnets
   - Calculate for each subnet: Network address, First usable IP, Last usable IP, Broadcast address

3. **Configure multiple IP addresses**:

```bash
# Add a second IP address to an interface
sudo ip addr add 192.168.10.10/24 dev eth0

# Verify configuration
ip addr show dev eth0

# Remove the IP address
sudo ip addr del 192.168.10.10/24 dev eth0
```

4. **Design an addressing scheme**:
   - Create a logical addressing scheme for a small office with:
     - 20 employee workstations
     - 5 printers
     - 3 servers
     - Guest WiFi network
     - Management network

#### **Lab Questions**:
1. What is the difference between 192.168.1.0/24 and 192.168.1.0/25?
2. How many usable IP addresses are in a /29 subnet?
3. Why would you create multiple subnets in a network?
4. What happens when two devices have the same IP address?

### <span style="color: #FF6347;">📊 Exercise 3: Network Traffic Analysis</span>

#### **Objective**: 
Learn to capture and analyze network traffic.

#### **Tasks**:

1. **Capture network traffic**:

```bash
# Install packet capturing tools
sudo apt install tcpdump wireshark -y  # For Debian/Ubuntu
sudo yum install tcpdump wireshark -y  # For CentOS/RHEL

# Capture traffic on an interface
sudo tcpdump -i eth0 -w capture.pcap

# Capture with filter (e.g., HTTP traffic)
sudo tcpdump -i eth0 port 80 -w http_traffic.pcap
```

2. **Generate test traffic**:
   - Open a web browser and visit several websites
   - Use various protocols: HTTP, HTTPS, DNS, etc.
   - Download a small file

3. **Analyze the captured traffic**:

```bash
# Basic analysis with tcpdump
sudo tcpdump -r capture.pcap -n

# Count packets by protocol
sudo tcpdump -r capture.pcap -n | grep -c "TCP"
sudo tcpdump -r capture.pcap -n | grep -c "UDP"
sudo tcpdump -r capture.pcap -n | grep -c "ICMP"

# Use Wireshark (GUI) for detailed analysis
wireshark capture.pcap
```

4. **Identify common protocols**:
   - Identify HTTP requests and responses
   - Find DNS queries and answers
   - Observe the TCP handshake process

#### **Lab Questions**:
1. What is the most common protocol in your capture?
2. Can you identify any plain-text passwords? (If yes, which protocols allow this?)
3. How many TCP connections were established during the capture?
4. What information can you learn about a user just by analyzing their network traffic?

---

## 🔄 Intermediate Exercises

### <span style="color: #FF8C00;">🌐 Exercise 4: Network Routing Scenarios</span>

#### **Objective**: 
Understand and configure routing between different networks.

#### **Tasks**:

1. **Set up multiple networks**:
   - Create two VMs with different subnets
   - VM1: 192.168.1.0/24 (192.168.1.10)
   - VM2: 192.168.2.0/24 (192.168.2.10)

2. **Configure routing between networks**:
   - Create a third VM to act as a router with interfaces on both networks
   - Enable IP forwarding on the router VM:

```bash
# Enable IP forwarding
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward

# Make it persistent
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

3. **Add static routes**:
   - On VM1, add a route to reach VM2's network:

```bash
# Add route to 192.168.2.0/24 via the router
sudo ip route add 192.168.2.0/24 via <router-ip-on-network1>

# Make persistent across reboots (Ubuntu)
echo "up ip route add 192.168.2.0/24 via <router-ip-on-network1>" | sudo tee -a /etc/network/interfaces.d/eth0
```

   - On VM2, add a route to reach VM1's network

4. **Test connectivity**:
   - Ping from VM1 to VM2 and vice versa
   - Trace the route path:

```bash
# Install traceroute
sudo apt install traceroute -y  # For Debian/Ubuntu
sudo yum install traceroute -y  # For CentOS/RHEL

# Trace route
traceroute <destination-ip>
```

5. **Implement a simple firewall**:
   - On the router VM, add iptables rules to control traffic:

```bash
# Allow established connections
sudo iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow traffic from VM1 to VM2
sudo iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT

# Block specific traffic (e.g., ICMP from VM2 to VM1)
sudo iptables -A FORWARD -i eth1 -o eth0 -p icmp -j DROP
```

#### **Lab Questions**:
1. What happens if IP forwarding is disabled on the router?
2. Why do both VMs need routes to each other's networks?
3. How would the setup change if you had more than two networks?
4. What are the security implications of allowing all traffic between networks?

### <span style="color: #4169E1;">🔒 Exercise 5: Network Services Configuration</span>

#### **Objective**: 
Set up and configure common network services.

#### **Tasks**:

1. **Configure a DHCP Server**:

```bash
# Install DHCP server
sudo apt install isc-dhcp-server -y  # For Debian/Ubuntu
sudo yum install dhcp-server -y     # For CentOS/RHEL

# Configure DHCP server
sudo nano /etc/dhcp/dhcpd.conf

# Add configuration:
subnet 192.168.1.0 netmask 255.255.255.0 {
  range 192.168.1.100 192.168.1.200;
  option routers 192.168.1.1;
  option domain-name-servers 8.8.8.8, 8.8.4.4;
}

# Start and enable the service
sudo systemctl start isc-dhcp-server
sudo systemctl enable isc-dhcp-server
```

2. **Set up a DNS Server**:

```bash
# Install DNS server
sudo apt install bind9 -y  # For Debian/Ubuntu
sudo yum install bind -y   # For CentOS/RHEL

# Configure DNS server
sudo nano /etc/bind/named.conf.local

# Add zone:
zone "example.lab" {
  type master;
  file "/etc/bind/db.example.lab";
};

# Create zone file
sudo nano /etc/bind/db.example.lab

# Add zone data:
$TTL 86400
@   IN  SOA     ns1.example.lab. admin.example.lab. (
        2023010101  ; Serial
        3600        ; Refresh
        1800        ; Retry
        604800      ; Expire
        86400 )     ; Minimum TTL
@   IN  NS      ns1.example.lab.
@   IN  A       192.168.1.10
ns1 IN  A       192.168.1.10
www IN  A       192.168.1.20
db  IN  A       192.168.1.30

# Start and enable the service
sudo systemctl start bind9
sudo systemctl enable bind9
```

3. **Configure a Web Server**:

```bash
# Install web server
sudo apt install nginx -y  # For Debian/Ubuntu
sudo yum install nginx -y  # For CentOS/RHEL

# Create a test page
echo "<html><body><h1>Network Services Lab</h1><p>Web server is working!</p></body></html>" | sudo tee /var/www/html/index.html

# Start and enable the service
sudo systemctl start nginx
sudo systemctl enable nginx
```

4. **Test all services**:
   - Test DHCP by configuring a client to get an IP address automatically
   - Test DNS resolution using dig or nslookup
   - Access the web server from another machine

#### **Lab Questions**:
1. What happens when multiple DHCP servers exist on the same network?
2. Why is DNS important in a network?
3. How would you secure these network services?
4. What additional services would be useful in a corporate network?

### <span style="color: #8B008B;">🔄 Exercise 6: Network Monitoring and Troubleshooting</span>

#### **Objective**: 
Learn to monitor network performance and troubleshoot issues.

#### **Tasks**:

1. **Set up network monitoring**:

```bash
# Install monitoring tools
sudo apt install iftop iperf3 nethogs -y  # For Debian/Ubuntu
sudo yum install iftop iperf3 nethogs -y  # For CentOS/RHEL

# Monitor bandwidth usage
sudo iftop -i eth0

# Monitor per-process network usage
sudo nethogs eth0
```

2. **Measure network performance**:
   - Set up iperf3 server on one VM:

```bash
# Start iperf3 server
iperf3 -s
```

   - Run iperf3 client on another VM:

```bash
# Run iperf3 client test
iperf3 -c <server-ip>

# Test with different options
iperf3 -c <server-ip> -t 30  # 30-second test
iperf3 -c <server-ip> -u     # UDP test
```

3. **Simulate and troubleshoot network issues**:
   - Introduce packet loss:

```bash
# Add 10% packet loss to an interface
sudo tc qdisc add dev eth0 root netem loss 10%

# Remove the simulation
sudo tc qdisc del dev eth0 root
```

   - Add network latency:

```bash
# Add 100ms latency
sudo tc qdisc add dev eth0 root netem delay 100ms

# Remove the simulation
sudo tc qdisc del dev eth0 root
```

4. **Analyze the impact**:
   - Measure performance before and after introducing issues
   - Document the symptoms of each type of network problem
   - Use troubleshooting tools to diagnose the issues

#### **Lab Questions**:
1. How does packet loss affect different protocols (TCP vs UDP)?
2. What performance metrics are most important to monitor?
3. How can you distinguish between network issues and application issues?
4. What tools would you use to diagnose intermittent network problems?

---

## 🔬 Network Simulation Labs

### <span style="color: #2E8B57;">🧪 Lab 1: Building a Multi-VLAN Network</span>

#### **Objective**: 
Design and implement a network with multiple VLANs.

#### **Setup Requirements**:
- 1 Router VM (with multiple interfaces)
- 2-3 Switch VMs (can use Linux with bridge-utils)
- 3-4 Client VMs

#### **Tasks**:

1. **Design the VLAN architecture**:
   - VLAN 10: Engineering (192.168.10.0/24)
   - VLAN 20: Marketing (192.168.20.0/24)
   - VLAN 30: Management (192.168.30.0/24)

2. **Configure switches with VLANs**:
   - Using Linux bridges and VLAN tagging:

```bash
# Install required packages
sudo apt install bridge-utils vlan

# Enable VLAN module
sudo modprobe 8021q

# Create VLANs
sudo vconfig add eth0 10
sudo vconfig add eth0 20
sudo vconfig add eth0 30

# Create bridges for each VLAN
sudo brctl addbr br10
sudo brctl addbr br20
sudo brctl addbr br30

# Add VLAN interfaces to bridges
sudo brctl addif br10 eth0.10
sudo brctl addif br20 eth0.20
sudo brctl addif br30 eth0.30

# Bring up interfaces
sudo ip link set up dev eth0.10
sudo ip link set up dev eth0.20
sudo ip link set up dev eth0.30
sudo ip link set up dev br10
sudo ip link set up dev br20
sudo ip link set up dev br30
```

3. **Configure inter-VLAN routing**:
   - Set up router-on-a-stick configuration
   - Configure router interfaces for each VLAN
   - Enable routing between VLANs

4. **Test connectivity**:
   - Ensure hosts in the same VLAN can communicate
   - Test routing between different VLANs
   - Implement and test VLAN access restrictions

#### **Expected Outcome**:
A functioning network with separate VLANs and controlled inter-VLAN routing.

### <span style="color: #B8860B;">🔬 Lab 2: Network Security Zones</span>

#### **Objective**: 
Implement network security zones with different security levels.

#### **Setup Requirements**:
- 1 Router/Firewall VM
- 1 DMZ Switch VM
- 1 Internal Switch VM
- 2-3 Server VMs
- 2-3 Client VMs

#### **Tasks**:

1. **Design the security architecture**:
   - DMZ (Demilitarized Zone): 192.168.100.0/24
   - Internal Network: 192.168.200.0/24
   - Management Network: 192.168.300.0/24

2. **Configure network segments**:
   - Set up physical/virtual interfaces for each zone
   - Configure IP addressing for each segment

3. **Implement firewall rules**:
   - Allow web traffic from anywhere to DMZ servers:

```bash
# Allow HTTP/HTTPS to DMZ web server
sudo iptables -A FORWARD -p tcp -d 192.168.100.10 --dport 80 -j ACCEPT
sudo iptables -A FORWARD -p tcp -d 192.168.100.10 --dport 443 -j ACCEPT

# Allow established connections back
sudo iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
```

   - Allow internal users to access DMZ and Internet
   - Block DMZ from initiating connections to internal network
   - Restrict management network access

4. **Test security zones**:
   - Verify allowed traffic flows correctly
   - Confirm blocked traffic is properly restricted
   - Document security policy implementation

#### **Expected Outcome**:
A secure network with properly segmented zones and enforced security policies.

---

## 🏢 Enterprise Network Labs

### <span style="color: #483D8B;">🌐 Lab 3: Site-to-Site VPN Setup</span>

#### **Objective**: 
Establish a secure site-to-site VPN connection between two networks.

#### **Setup Requirements**:
- 2 Router VMs (one for each "site")
- 2-3 Client VMs per site
- Internet connectivity simulation

#### **Tasks**:

1. **Configure the network topology**:
   - Site A: 10.1.0.0/16
   - Site B: 10.2.0.0/16
   - "Internet" network between routers

2. **Set up IPsec VPN using strongSwan**:
   - Install strongSwan on both routers:

```bash
sudo apt install strongswan

# On Site A router
sudo nano /etc/ipsec.conf
# Add configuration:
conn site-to-site
    left=<Site-A-Public-IP>
    leftsubnet=10.1.0.0/16
    right=<Site-B-Public-IP>
    rightsubnet=10.2.0.0/16
    ike=aes256-sha1-modp1024
    esp=aes256-sha1
    keyingtries=0
    ikelifetime=1h
    lifetime=8h
    dpddelay=30
    dpdtimeout=120
    dpdaction=restart
    authby=secret
    auto=start

# Configure shared secret
sudo nano /etc/ipsec.secrets
# Add:
<Site-A-Public-IP> <Site-B-Public-IP> : PSK "SecureSharedSecret123!"
```

3. **Start VPN services and verify connection**:

```bash
# Start strongSwan
sudo systemctl start strongswan

# Check VPN status
sudo ipsec status

# Verify tunnel is established
sudo ipsec statusall | grep -i established
```

4. **Test connectivity across the VPN**:
   - Ping from clients in Site A to clients in Site B
   - Transfer files between sites
   - Monitor VPN tunnel traffic

#### **Expected Outcome**:
A functioning site-to-site VPN connecting two separate networks securely.

### <span style="color: #CD5C5C;">🌍 Lab 4: Load Balancing and High Availability</span>

#### **Objective**: 
Implement load balancing and high availability for web services.

#### **Setup Requirements**:
- 1 Load Balancer VM
- 3 Web Server VMs
- 2 Client VMs for testing

#### **Tasks**:

1. **Set up web servers**:
   - Install web server software on each server:

```bash
# Install Nginx
sudo apt install nginx

# Create unique test page
echo "<html><body><h1>Server $(hostname)</h1></body></html>" | sudo tee /var/www/html/index.html
```

2. **Configure HAProxy load balancer**:

```bash
# Install HAProxy
sudo apt install haproxy

# Configure HAProxy
sudo nano /etc/haproxy/haproxy.cfg
# Add configuration:
frontend http_front
   bind *:80
   stats uri /haproxy?stats
   default_backend http_back

backend http_back
   balance roundrobin
   server web1 192.168.1.101:80 check
   server web2 192.168.1.102:80 check
   server web3 192.168.1.103:80 check
```

3. **Implement high availability**:
   - Set up Keepalived for floating IP:

```bash
# Install Keepalived
sudo apt install keepalived

# Configure Keepalived
sudo nano /etc/keepalived/keepalived.conf
# Add configuration:
vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 51
    priority 101
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass SecurePassword
    }
    virtual_ipaddress {
        192.168.1.200
    }
}
```

4. **Test load balancing and failover**:
   - Send multiple requests to verify round-robin distribution
   - Simulate server failure and observe behavior
   - Test high availability by taking down the primary load balancer

```bash
# Test load distribution
for i in {1..20}; do curl -s http://192.168.1.200 | grep Server; done

# Monitor HAProxy stats
curl http://192.168.1.200/haproxy?stats
```

#### **Expected Outcome**:
A highly available web service with load balancing that can survive individual server failures.

---

## 🔒 Network Security Challenges

### <span style="color: #FF4500;">🔐 Challenge 1: Network Intrusion Detection</span>

#### **Objective**: 
Set up and configure an intrusion detection system to monitor network traffic.

#### **Tasks**:

1. **Install and configure Snort IDS**:

```bash
# Install Snort
sudo apt install snort

# Configure Snort for your network
sudo nano /etc/snort/snort.conf
# Update HOME_NET variable with your network
# ipvar HOME_NET 192.168.1.0/24
```

2. **Create custom detection rules**:
   - Add a rule to detect port scanning:

```bash
# Create custom rules file
sudo nano /etc/snort/rules/local.rules

# Add port scan detection rule
alert tcp any any -> $HOME_NET any (msg:"Possible port scan"; flags:S; threshold: type threshold, track by_src, count 5, seconds 2; sid:1000001; rev:1;)
```

3. **Start Snort in IDS mode**:

```bash
# Run Snort in IDS mode
sudo snort -A console -q -c /etc/snort/snort.conf -i eth0
```

4. **Generate test traffic**:
   - Perform a port scan from another machine:

```bash
# Install nmap if not available
sudo apt install nmap

# Perform port scan
sudo nmap -sS 192.168.1.0/24
```

5. **Analyze alerts and tune rules**:
   - Review Snort alerts
   - Adjust rules to reduce false positives
   - Create additional custom rules

#### **Challenge Questions**:
1. What types of attacks can be detected with network-based IDS?
2. How would you differentiate between normal and malicious traffic?
3. What are the limitations of network-based intrusion detection?

### <span style="color: #6A5ACD;">🔎 Challenge 2: Network Forensics Investigation</span>

#### **Objective**: 
Conduct a network forensic analysis on captured traffic to identify suspicious activities.

#### **Tasks**:

1. **Capture traffic for analysis**:

```bash
# Capture traffic to a file
sudo tcpdump -i eth0 -s 0 -w investigation.pcap
```

2. **Introduce suspicious activities**:
   - Generate various types of traffic:
     - Normal web browsing
     - SSH connections
     - File downloads
     - Port scanning
     - Malicious attack simulation (e.g., brute force login attempts)

3. **Analyze the captured traffic**:

```bash
# Install analysis tools
sudo apt install wireshark-qt tshark

# Basic analysis with tshark
tshark -r investigation.pcap -q -z io,phs  # Protocol hierarchy
tshark -r investigation.pcap -q -z expert  # Expert information

# Find potential SSH brute force attempts
tshark -r investigation.pcap -Y "tcp.port == 22" | grep -c SYN

# Extract HTTP user agents
tshark -r investigation.pcap -Y "http.user_agent" -T fields -e http.user_agent | sort | uniq -c
```

4. **Create a forensic report**:
   - Document all findings
   - Identify suspicious activities with evidence
   - Recommend security improvements

#### **Challenge Questions**:
1. What indicators would suggest a potential security breach?
2. How can you distinguish between normal and malicious SSH connections?
3. What information could be extracted from HTTP traffic?
4. How would you detect data exfiltration in a network capture?

---

## 📝 Lab Solutions & Expected Results

### <span style="color: #4682B4;">🔰 Exercise 1: Network Discovery Solution</span>

**Expected Results**:
- Discovery of all network devices
- Identification of open services and ports
- Network map showing connected devices
- Documentation of network inventory

**Example nmap output**:
```
Starting Nmap 7.80 ( https://nmap.org )
Nmap scan report for router.home (192.168.1.1)
Host is up (0.0023s latency).
Not shown: 995 closed ports
PORT    STATE SERVICE
22/tcp  open  ssh
53/tcp  open  domain
80/tcp  open  http
443/tcp open  https
MAC Address: 00:11:22:33:44:55 (Vendor Inc.)

Nmap scan report for laptop.home (192.168.1.100)
Host is up (0.0045s latency).
Not shown: 998 closed ports
PORT    STATE SERVICE
22/tcp  open  ssh
3000/tcp open  ppp
MAC Address: AA:BB:CC:DD:EE:FF (Computer Corp.)
```

### <span style="color: #9370DB;">🔰 Exercise 2: Subnetting Solution</span>

**Expected Results**:
- Calculation of subnet information
- Division of network into subnets
- Configuration of IP addresses
- Complete addressing scheme

**Example subnet division**:
```
192.168.10.0/24 divided into 4 equal subnets:

Subnet 1: 192.168.10.0/26
- Network: 192.168.10.0
- First IP: 192.168.10.1
- Last IP: 192.168.10.62
- Broadcast: 192.168.10.63

Subnet 2: 192.168.10.64/26
- Network: 192.168.10.64
- First IP: 192.168.10.65
- Last IP: 192.168.10.126
- Broadcast: 192.168.10.127

Subnet 3: 192.168.10.128/26
- Network: 192.168.10.128
- First IP: 192.168.10.129
- Last IP: 192.168.10.190
- Broadcast: 192.168.10.191

Subnet 4: 192.168.10.192/26
- Network: 192.168.10.192
- First IP: 192.168.10.193
- Last IP: 192.168.10.254
- Broadcast: 192.168.10.255
```

### <span style="color: #FF6347;">🔰 Exercise 3: Traffic Analysis Solution</span>

**Expected Results**:
- Successful traffic capture
- Analysis of protocols and connections
- Identification of HTTP requests/responses
- DNS query analysis

**Example protocol distribution**:
```
Protocol Hierarchy Statistics
============================
eth                                frames:1452 bytes:1251343
  ip                               frames:1442 bytes:1250143
    tcp                            frames:1201 bytes:1199461
      ssl                          frames:543 bytes:765490
      http                         frames:346 bytes:345200
    udp                            frames:241 bytes:50682
      dns                          frames:126 bytes:16443
    icmp                           frames:0 bytes:0
```

### <span style="color: #FF8C00;">🔄 Exercise 4: Routing Solution</span>

**Expected Results**:
- Successful routing between networks
- Verified connectivity between VMs
- Traceroute showing path through router
- Firewall rules controlling traffic

**Example traceroute output**:
```
traceroute to 192.168.2.10 (192.168.2.10), 30 hops max, 60 byte packets
 1  router (192.168.1.1)  0.355 ms  0.331 ms  0.297 ms
 2  192.168.2.10 (192.168.2.10)  0.578 ms  0.546 ms  0.513 ms
```

### <span style="color: #4169E1;">🔄 Exercise 5: Network Services Solution</span>

**Expected Results**:
- Functioning DHCP server assigning addresses
- DNS server resolving custom domains
- Web server delivering content
- All services working together

**Example DNS resolution test**:
```
$ dig www.example.lab @192.168.1.10

;; ANSWER SECTION:
www.example.lab.    86400   IN   A   192.168.1.20
```

### <span style="color: #8B008B;">🔄 Exercise 6: Network Monitoring Solution</span>

**Expected Results**:
- Network performance measurements
- Simulated network issues
- Performance impact analysis
- Successful troubleshooting

**Example iperf3 output (normal)**:
```
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.13 GBytes   970 Mbits/sec    0
```

**Example iperf3 output (with 10% packet loss)**:
```
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  387 MBytes   325 Mbits/sec  1245
```

---

## 📚 Additional Resources

### <span style="color: #2E8B57;">📖 Recommended Reading</span>

- **Network Warrior** by Gary A. Donahue
- **TCP/IP Illustrated** by W. Richard Stevens
- **Practical Packet Analysis** by Chris Sanders

### <span style="color: #CD853F;">🛠️ Useful Tools</span>

- **Network Simulators**:
  - GNS3: https://www.gns3.com/
  - Cisco Packet Tracer (educational): https://www.netacad.com/
  - EVE-NG: https://www.eve-ng.net/

- **Network Analysis Tools**:
  - Wireshark: https://www.wireshark.org/
  - tcpdump: https://www.tcpdump.org/
  - iperf3: https://iperf.fr/

- **Network Calculators**:
  - IP Calculator: https://jodies.de/ipcalc
  - CIDR Calculator: http://www.subnet-calculator.com/

### <span style="color: #4682B4;">🌐 Online Labs and Practice</span>

- **Hands-On Lab Platforms**:
  - Katacoda: https://www.katacoda.com/
  - Cisco DevNet: https://developer.cisco.com/
  - NetworkLessons: https://networklessons.com/

- **Practice Challenges**:
  - NetKotH: Network King of the Hill challenges
  - Cyber Defense exercises
  - CTF Network challenges

---

<div align="center">
  <h3 style="color: #5F9EA0;">🎉 You've Completed the Networking Basics Labs!</h3>
  <p>Continue your journey by expanding these labs or creating your own scenarios!</p>
  <p><strong>Next Steps:</strong> <em>Explore Kubernetes, Docker, or Cloud Networking</em></p>
</div>

---

<div align="center">
  <p><small>Part of the 30 Days DevOps Zero to Intermediate Journey</small></p>
</div>