# 🌐 Day 3 - Networking Basics

<div align="center">
  <h2 style="color: #2E8B57;">Welcome to Networking Fundamentals!</h2>
  <p><em>Master the foundation of modern IT infrastructure</em></p>
</div>

---

## 📋 Table of Contents

- [🎯 Learning Objectives](#-learning-objectives)
- [⚡ Prerequisites](#-prerequisites)
- [📚 Course Structure](#-course-structure)
- [🛠️ Tools and Environment Setup](#️-tools-and-environment-setup)
- [📖 Study Materials](#-study-materials)
- [🧪 Practice Labs](#-practice-labs)
- [🔍 Assessment](#-assessment)
- [🚀 Next Steps](#-next-steps)
- [📞 Getting Help](#-getting-help)

---

## 🎯 Learning Objectives

By the end of this day, you will be able to:

### <span style="color: #4169E1;">🔍 Fundamental Knowledge</span>
- ✅ Understand the OSI model and its 7 layers
- ✅ Explain the TCP/IP protocol suite
- ✅ Differentiate between TCP and UDP protocols
- ✅ Understand IP addressing and CIDR notation
- ✅ Perform basic subnetting calculations

### <span style="color: #FF6347;">🛠️ Practical Skills</span>
- ✅ Use essential networking commands (`ping`, `traceroute`, `nslookup`, etc.)
- ✅ Configure basic network settings
- ✅ Troubleshoot common network connectivity issues
- ✅ Analyze network traffic using basic tools
- ✅ Set up and test network services

### <span style="color: #32CD32;">📊 DevOps Integration</span>
- ✅ Understand how networking impacts DevOps practices
- ✅ Configure network settings for containerized applications
- ✅ Implement basic network security practices
- ✅ Monitor network performance and health

---

## ⚡ Prerequisites

### <span style="color: #FF4500;">📖 Knowledge Requirements</span>
- Basic understanding of computers and operating systems
- Completion of Day 1 (Linux Basics) and Day 2 (Linux Advanced)
- Familiarity with command-line interfaces

### <span style="color: #9370DB;">💻 Technical Requirements</span>
- Linux/Windows/macOS computer with admin privileges
- Virtual machine software (VirtualBox, VMware, or Hyper-V)
- Internet connection for downloading tools and testing
- Text editor (VS Code recommended)

### <span style="color: #DC143C;">⏰ Time Investment</span>
- **Estimated completion time**: 6-8 hours
- **Theory study**: 2-3 hours
- **Hands-on practice**: 4-5 hours

---

## 📚 Course Structure

This day is organized into comprehensive modules:

### <span style="color: #4682B4;">📂 Module 1: Networking Fundamentals</span>
**File**: `01-networking-fundamentals.md`
- OSI Model deep dive
- TCP/IP Protocol Suite
- Network protocols overview
- Port numbers and services
- Network topologies

### <span style="color: #228B22;">📂 Module 2: IP Addressing and Subnetting</span>
**File**: `02-ip-addressing-subnetting.md`
- IPv4 addressing concepts
- CIDR notation explained
- Subnetting step-by-step
- VLSM (Variable Length Subnet Masking)
- IPv6 introduction

### <span style="color: #B8860B;">📂 Module 3: Network Commands and Tools</span>
**File**: `03-network-commands.md`
- Essential Linux networking commands
- Windows networking utilities
- Network diagnostic tools
- Packet capture basics
- Performance monitoring tools

### <span style="color: #CD5C5C;">📂 Module 4: Network Troubleshooting</span>
**File**: `04-network-troubleshooting.md`
- Systematic troubleshooting methodology
- Common network issues and solutions
- Layer-by-layer diagnostic approach
- Tools for network analysis
- Case studies and scenarios

### <span style="color: #20B2AA;">📂 Module 5: Practical Exercises</span>
**File**: `05-exercises-and-labs.md`
- Hands-on lab exercises
- Real-world scenarios
- Step-by-step walkthroughs
- Challenge problems
- Solution guides

---

## 🛠️ Tools and Environment Setup

### <span style="color: #FF1493;">🐧 Linux Environment</span>

```bash
# Update package manager
sudo apt update && sudo apt upgrade -y

# Install essential networking tools
sudo apt install -y net-tools iputils-ping traceroute nmap wireshark tcpdump dnsutils netcat-openbsd

# Install advanced tools
sudo apt install -y iftop htop iotop nload nethogs
```

### <span style="color: #0000CD;">🪟 Windows Environment</span>

```cmd
# Enable Windows Subsystem for Linux (Optional)
wsl --install

# Install Windows networking tools (if not already available)
# Most tools like ping, tracert, nslookup are built-in

# Install additional tools using Chocolatey
choco install wireshark nmap putty
```

### <span style="color: #8B4513;">🔧 Verification Commands</span>

Test your environment setup:

```bash
# Check if tools are installed
ping --version
traceroute --version
nmap --version
dig --version

# Test network connectivity
ping -c 4 8.8.8.8
nslookup google.com
```

---

## 📖 Study Materials

### <span style="color: #FF6347;">📚 Required Reading</span>
1. **Networking Fundamentals** - `01-networking-fundamentals.md`
2. **IP Addressing Guide** - `02-ip-addressing-subnetting.md`
3. **Network Commands Reference** - `03-network-commands.md`
4. **Troubleshooting Manual** - `04-network-troubleshooting.md`

### <span style="color: #32CD32;">🔗 Recommended Resources</span>
- [Cisco Networking Basics](https://www.cisco.com/c/en/us/solutions/small-business/resource-center/networking/networking-basics.html)
- [TCP/IP Guide](http://www.tcpipguide.com/)
- [Wireshark Documentation](https://www.wireshark.org/docs/)
- [RFC 791 - Internet Protocol](https://tools.ietf.org/html/rfc791)

### <span style="color: #9370DB;">🎥 Video Resources</span>
- NetworkChuck YouTube Channel
- Professor Messer's Network+ Course
- Cisco NetAcad Introduction to Networks

---

## 🧪 Practice Labs

### <span style="color: #FF4500;">🔬 Lab Environment Setup</span>

```bash
# Create lab directory
mkdir -p ~/networking-labs/day3
cd ~/networking-labs/day3

# Create network simulation scripts
mkdir scripts configs logs
```

### <span style="color: #4169E1;">🧪 Available Labs</span>

| Lab | Description | Duration | Difficulty |
|-----|-------------|----------|------------|
| Lab 1 | Basic Network Discovery | 30 min | Beginner |
| Lab 2 | IP Address Configuration | 45 min | Beginner |
| Lab 3 | Subnetting Practice | 60 min | Intermediate |
| Lab 4 | Network Troubleshooting | 75 min | Intermediate |
| Lab 5 | Traffic Analysis | 90 min | Advanced |

---

## 🔍 Assessment

### <span style="color: #DC143C;">📝 Knowledge Check</span>
- Complete the quiz in each module
- Solve subnetting problems
- Explain network troubleshooting steps

### <span style="color: #228B22;">🛠️ Practical Assessment</span>
- Configure network interfaces
- Diagnose connectivity issues
- Analyze network traffic
- Document findings and solutions

### <span style="color: #B8860B;">📊 Success Criteria</span>
- ✅ 80% score on knowledge assessments
- ✅ Successfully complete all labs
- ✅ Demonstrate troubleshooting skills
- ✅ Create network documentation

---

## 🚀 Next Steps

### <span style="color: #FF1493;">📈 After Completing This Day</span>
1. **Day 4**: Git Basics - Version control fundamentals
2. **Advanced Networking**: Explore VLAN, routing protocols
3. **Network Security**: Firewalls, VPN, and security practices
4. **Cloud Networking**: AWS VPC, Azure Virtual Networks

### <span style="color: #20B2AA;">🎯 Career Pathways</span>
- Network Administrator
- DevOps Engineer
- Cloud Engineer
- Security Specialist

---

## 📞 Getting Help

### <span style="color: #4682B4;">❓ When You're Stuck</span>
1. **Review the prerequisites** - Ensure you have the required knowledge
2. **Check the troubleshooting guide** - Common issues and solutions
3. **Practice with examples** - Work through provided scenarios
4. **Community support** - Engage with fellow learners

### <span style="color: #CD5C5C;">🔧 Technical Issues</span>
- Verify tool installations
- Check network connectivity
- Review configuration files
- Test with different approaches

### <span style="color: #8B4513;">📧 Contact Information</span>
- Create GitHub issues for content improvements
- Join community discussions
- Share your learning journey

---

## 📚 Quick Reference

### <span style="color: #FF6347;">🚀 Essential Commands Cheat Sheet</span>

```bash
# Network Interface Information
ip addr show                    # Show all interfaces (Linux)
ifconfig                       # Show network interfaces (Linux/macOS)
ipconfig                       # Show network configuration (Windows)

# Connectivity Testing
ping 8.8.8.8                   # Test connectivity to Google DNS
ping -c 4 example.com          # Ping with count limit
traceroute google.com          # Trace route to destination
tracert google.com             # Windows traceroute

# DNS Resolution
nslookup google.com            # DNS lookup
dig google.com                 # Detailed DNS information
host google.com                # Simple DNS lookup

# Network Scanning
nmap -sP 192.168.1.0/24       # Ping scan subnet
netstat -tuln                  # Show listening ports
ss -tuln                       # Modern netstat alternative
```

---

<div align="center">
  <h3 style="color: #2E8B57;">🎉 Ready to Start Your Networking Journey?</h3>
  <p>Begin with <strong>01-networking-fundamentals.md</strong> and work through each module systematically!</p>
  
  <p><em>Remember: Networking is the backbone of all modern IT infrastructure. Master these concepts, and you'll build a strong foundation for your DevOps career!</em></p>
</div>

---

<div align="center">
  <p><strong>Happy Learning! 🚀</strong></p>
  <p><small>Part of the 30 Days DevOps Zero to Intermediate Journey</small></p>
</div>