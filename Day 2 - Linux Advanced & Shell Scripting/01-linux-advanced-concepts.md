# 🐧 Linux Advanced Concepts

<div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px; border-radius: 10px; color: white; text-align: center;">
  <h2>🚀 Master Advanced Linux System Administration</h2>
  <p>From basic commands to system mastery</p>
</div>

---

## 📚 **Table of Contents**

1. [🔍 System Information & Monitoring](#-system-information--monitoring)
2. [⚡ Process Management](#-process-management)
3. [💾 Memory & Storage Management](#-memory--storage-management)
4. [🌐 Network Management](#-network-management)
5. [👥 User & Group Management](#-user--group-management)
6. [🔧 System Services & Systemd](#-system-services--systemd)
7. [📊 Performance Monitoring](#-performance-monitoring)
8. [🔒 System Security Basics](#-system-security-basics)
9. [📁 Advanced File Operations](#-advanced-file-operations)
10. [🛠️ Troubleshooting Techniques](#️-troubleshooting-techniques)

---

## 🔍 **System Information & Monitoring**

### 📊 **System Overview Commands**

Understanding your system is the first step to mastering Linux administration.

```bash
# Display system information
uname -a                    # Complete system information
hostnamectl                 # System hostname and related info
uptime                      # System uptime and load
whoami                      # Current user
id                          # User and group IDs
```

**💡 Pro Tip:** Create an alias for quick system overview:

```bash
# Add to ~/.bashrc
alias sysinfo='echo "=== SYSTEM INFO ===" && uname -a && echo && echo "=== UPTIME ===" && uptime && echo && echo "=== MEMORY ===" && free -h && echo && echo "=== DISK ===" && df -h'
```

### 🖥️ **Hardware Information**

```bash
# CPU information
lscpu                       # Detailed CPU info
cat /proc/cpuinfo          # Raw CPU data
nproc                      # Number of processing units

# Memory information
free -h                    # Human-readable memory usage
cat /proc/meminfo          # Detailed memory information
vmstat                     # Virtual memory statistics

# Disk and storage
lsblk                      # List block devices
fdisk -l                   # List disk partitions (requires sudo)
df -h                      # Disk space usage
du -sh /path/to/directory  # Directory size

# Hardware listing
lshw                       # Complete hardware information
lspci                      # PCI devices
lsusb                      # USB devices
```

### 📈 **Real-time System Monitoring**

```bash
# Real-time process monitoring
top                        # Traditional process viewer
htop                       # Enhanced process viewer (if installed)
btop                       # Modern resource monitor (if installed)

# I/O monitoring
iotop                      # I/O usage by process
iostat 1 5                # I/O statistics every 1 second, 5 times

# Network monitoring
iftop                      # Network bandwidth usage
nethogs                   # Network usage by process
ss -tulpn                 # Socket statistics
```

---

## ⚡ **Process Management**

### 🏃‍♂️ **Understanding Processes**

Every running program in Linux is a process with a unique Process ID (PID).

```bash
# List all processes
ps aux                     # All processes with detailed info
ps -ef                     # All processes in full format
pstree                     # Process tree view

# Find specific processes
ps aux | grep nginx        # Find nginx processes
pgrep -f "process_name"    # Get PID by name
pidof process_name         # Get PID of running process
```

### 🎛️ **Process Control**

```bash
# Start processes
command &                  # Run in background
nohup command &           # Run immune to hangups
disown                    # Remove job from shell's job table

# Stop and control processes
kill PID                  # Terminate process by PID
kill -9 PID              # Force kill process
killall process_name      # Kill all processes by name
pkill -f "pattern"       # Kill processes matching pattern

# Job control
jobs                      # List active jobs
fg %1                     # Bring job 1 to foreground
bg %1                     # Send job 1 to background
Ctrl+Z                    # Suspend current process
Ctrl+C                    # Interrupt current process
```

### 🔄 **Advanced Process Management**

```bash
# Process priority
nice -n 10 command        # Start with lower priority
renice -n 5 PID          # Change priority of running process

# Monitor process resource usage
top -p PID               # Monitor specific process
strace command           # Trace system calls
ltrace command           # Trace library calls

# Process limits
ulimit -a                # Show all limits
ulimit -n 1024          # Set file descriptor limit
```

**🎯 Real-world Example:** Web Server Process Management

```bash
#!/bin/bash
# nginx-manager.sh - Manage nginx processes

check_nginx() {
    if pgrep nginx > /dev/null; then
        echo "✅ Nginx is running"
        echo "📊 Process count: $(pgrep nginx | wc -l)"
        echo "💾 Memory usage: $(ps -o pid,ppid,cmd,%mem,%cpu --sort=-%mem -C nginx)"
    else
        echo "❌ Nginx is not running"
    fi
}

restart_nginx() {
    echo "🔄 Restarting nginx..."
    sudo systemctl restart nginx
    sleep 2
    check_nginx
}

# Usage
case "$1" in
    check) check_nginx ;;
    restart) restart_nginx ;;
    *) echo "Usage: $0 {check|restart}" ;;
esac
```

---

## 💾 **Memory & Storage Management**

### 🧠 **Memory Management**

```bash
# Memory usage analysis
free -h                   # Memory usage summary
cat /proc/meminfo        # Detailed memory info
vmstat 1 5              # Virtual memory stats

# Memory per process
ps aux --sort=-%mem | head -10    # Top 10 memory-consuming processes
pmap PID                          # Memory map of a process

# Cache management
sudo sync                # Flush file system buffers
sudo echo 3 > /proc/sys/vm/drop_caches  # Clear caches (use carefully!)
```

### 💽 **Disk Management**

```bash
# Disk space monitoring
df -h                    # Filesystem disk usage
df -i                    # Inode usage
du -sh /var/log/*       # Directory sizes
ncdu /path              # Interactive disk usage analyzer

# Find large files
find / -type f -size +100M 2>/dev/null    # Files larger than 100MB
find /var/log -name "*.log" -mtime +30    # Old log files

# Disk I/O monitoring
iostat -x 1             # Extended I/O statistics
iotop -o                # Show only processes with I/O activity
```

### 🗂️ **Filesystem Operations**

```bash
# Mount and unmount
mount                    # Show mounted filesystems
mount /dev/sdb1 /mnt    # Mount device to directory
umount /mnt             # Unmount filesystem
lsof /mnt               # Show processes using mounted filesystem

# Filesystem checks
fsck /dev/sdb1          # Check filesystem (unmounted)
tune2fs -l /dev/sdb1    # Show filesystem parameters
blkid                   # Show block device attributes
```

**🎯 Real-world Example:** Automated Disk Cleanup Script

```bash
#!/bin/bash
# cleanup.sh - Automated system cleanup

set -euo pipefail

LOG_FILE="/var/log/cleanup.log"
THRESHOLD=80  # Cleanup when disk usage exceeds 80%

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

check_disk_usage() {
    local usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
    echo "$usage"
}

cleanup_logs() {
    log_message "🧹 Cleaning old log files..."
    
    # Remove logs older than 30 days
    find /var/log -name "*.log" -mtime +30 -type f -exec rm -f {} \;
    
    # Compress logs older than 7 days
    find /var/log -name "*.log" -mtime +7 -type f -exec gzip {} \;
    
    log_message "✅ Log cleanup completed"
}

cleanup_temp() {
    log_message "🗑️ Cleaning temporary files..."
    
    # Clean /tmp older than 7 days
    find /tmp -type f -mtime +7 -delete 2>/dev/null || true
    
    # Clean package cache (Ubuntu/Debian)
    if command -v apt-get >/dev/null; then
        apt-get clean
    fi
    
    log_message "✅ Temp cleanup completed"
}

main() {
    local current_usage=$(check_disk_usage)
    
    log_message "🔍 Current disk usage: ${current_usage}%"
    
    if [[ $current_usage -gt $THRESHOLD ]]; then
        log_message "⚠️ Disk usage above threshold (${THRESHOLD}%). Starting cleanup..."
        
        cleanup_logs
        cleanup_temp
        
        local new_usage=$(check_disk_usage)
        log_message "✨ Cleanup completed. New usage: ${new_usage}%"
    else
        log_message "✅ Disk usage within acceptable limits"
    fi
}

main "$@"
```

---

## 🌐 **Network Management**

### 🔌 **Network Configuration**

```bash
# Network interfaces
ip addr show            # Show network interfaces (modern)
ifconfig               # Show network interfaces (traditional)
ip link show           # Show network link status

# Network configuration
ip addr add 192.168.1.100/24 dev eth0    # Add IP address
ip route show                             # Show routing table
ip route add default via 192.168.1.1     # Add default route

# Network troubleshooting
ping -c 4 google.com    # Test connectivity
traceroute google.com   # Trace route to destination
nslookup google.com     # DNS lookup
dig google.com          # Advanced DNS lookup
```

### 🔍 **Network Monitoring**

```bash
# Active connections
netstat -tulpn          # Show listening ports
ss -tulpn               # Modern replacement for netstat
lsof -i                 # Show network connections by process

# Network statistics
netstat -i              # Interface statistics
cat /proc/net/dev       # Network device statistics
iftop                   # Real-time bandwidth usage
```

### 🛡️ **Firewall Basics**

```bash
# UFW (Uncomplicated Firewall)
sudo ufw status         # Check firewall status
sudo ufw enable         # Enable firewall
sudo ufw allow 22       # Allow SSH
sudo ufw allow 80/tcp   # Allow HTTP
sudo ufw deny 23        # Block Telnet

# iptables (Advanced)
sudo iptables -L        # List rules
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT  # Allow HTTP
```

**🎯 Real-world Example:** Network Health Check Script

```bash
#!/bin/bash
# network-check.sh - Comprehensive network health check

set -euo pipefail

HOSTS=("8.8.8.8" "1.1.1.1" "google.com")
PORTS=("22" "80" "443")

check_connectivity() {
    echo "🌐 Testing Internet Connectivity..."
    
    for host in "${HOSTS[@]}"; do
        if ping -c 3 -W 3 "$host" >/dev/null 2>&1; then
            echo "✅ $host - Reachable"
        else
            echo "❌ $host - Unreachable"
        fi
    done
}

check_ports() {
    echo -e "\n🔌 Checking Local Services..."
    
    for port in "${PORTS[@]}"; do
        if ss -tulpn | grep ":$port " >/dev/null; then
            service=$(ss -tulpn | grep ":$port " | awk '{print $7}' | head -1)
            echo "✅ Port $port - Active ($service)"
        else
            echo "❌ Port $port - Inactive"
        fi
    done
}

show_network_info() {
    echo -e "\n📊 Network Interface Information:"
    ip addr show | grep -E "^\d+:|inet " | sed 's/^/  /'
    
    echo -e "\n🛣️ Routing Table:"
    ip route show | sed 's/^/  /'
    
    echo -e "\n🔍 DNS Configuration:"
    cat /etc/resolv.conf | grep nameserver | sed 's/^/  /'
}

main() {
    echo "🔍 Network Health Check Report"
    echo "=============================="
    
    check_connectivity
    check_ports
    show_network_info
    
    echo -e "\n✅ Network health check completed!"
}

main "$@"
```

---

## 👥 **User & Group Management**

### 👤 **User Management**

```bash
# User information
whoami                  # Current user
id                      # User and group IDs
who                     # Logged in users
w                       # Detailed logged in users
last                    # Login history

# User management (requires sudo)
sudo useradd username           # Add user
sudo userdel username          # Delete user
sudo usermod -aG group user    # Add user to group
sudo passwd username           # Change password
sudo chage -l username         # Check password aging
```

### 👥 **Group Management**

```bash
# Group information
groups                  # Current user's groups
groups username        # Specific user's groups
getent group          # List all groups

# Group management (requires sudo)
sudo groupadd groupname        # Create group
sudo groupdel groupname       # Delete group
sudo gpasswd -a user group    # Add user to group
sudo gpasswd -d user group    # Remove user from group
```

### 🔐 **Sudo and Privileges**

```bash
# Sudo management
sudo -l                 # List allowed commands
sudo -u username command # Run command as different user
visudo                 # Edit sudoers file safely

# Switch users
su - username          # Switch to user with environment
sudo su -              # Switch to root
```

**🎯 Real-world Example:** User Audit Script

```bash
#!/bin/bash
# user-audit.sh - Comprehensive user audit

set -euo pipefail

generate_user_report() {
    local username="$1"
    
    echo "👤 User: $username"
    echo "   ID: $(id "$username" 2>/dev/null || echo "N/A")"
    echo "   Groups: $(groups "$username" 2>/dev/null || echo "N/A")"
    echo "   Shell: $(getent passwd "$username" | cut -d: -f7)"
    echo "   Home: $(getent passwd "$username" | cut -d: -f6)"
    
    # Check last login
    local last_login=$(last -1 "$username" 2>/dev/null | head -1)
    if [[ $last_login != *"wtmp begins"* ]]; then
        echo "   Last Login: $last_login"
    else
        echo "   Last Login: Never"
    fi
    
    # Check sudo privileges
    if sudo -l -U "$username" 2>/dev/null | grep -q "may run"; then
        echo "   Sudo: ✅ Has privileges"
    else
        echo "   Sudo: ❌ No privileges"
    fi
    
    echo
}

main() {
    echo "🔍 System User Audit Report"
    echo "=========================="
    echo "Generated: $(date)"
    echo
    
    # Get all system users (UID >= 1000)
    local users=$(getent passwd | awk -F: '$3 >= 1000 {print $1}' | sort)
    
    if [[ -z "$users" ]]; then
        echo "❌ No regular users found"
        exit 0
    fi
    
    echo "📊 Found $(echo "$users" | wc -l) regular users:"
    echo
    
    for user in $users; do
        generate_user_report "$user"
    done
    
    echo "✅ User audit completed!"
}

main "$@"
```

---

## 🔧 **System Services & Systemd**

### ⚙️ **Systemd Basics**

Systemd is the modern init system and service manager for Linux.

```bash
# Service management
sudo systemctl start service_name      # Start service
sudo systemctl stop service_name       # Stop service
sudo systemctl restart service_name    # Restart service
sudo systemctl reload service_name     # Reload configuration
sudo systemctl enable service_name     # Enable at boot
sudo systemctl disable service_name    # Disable at boot

# Service status
systemctl status service_name          # Detailed service status
systemctl is-active service_name       # Check if active
systemctl is-enabled service_name      # Check if enabled
systemctl list-units --type=service    # List all services
```

### 📊 **System Analysis**

```bash
# System state
systemctl list-units --failed          # Show failed units
systemctl list-jobs                     # Show active jobs
systemctl list-dependencies            # Show dependencies

# Boot analysis
systemd-analyze                         # Boot time analysis
systemd-analyze blame                   # Show slowest services
systemd-analyze critical-chain          # Show critical boot path
```

### 📝 **Logging with journalctl**

```bash
# View logs
journalctl                             # All logs
journalctl -u service_name             # Service-specific logs
journalctl -f                          # Follow logs (like tail -f)
journalctl --since "1 hour ago"        # Recent logs
journalctl --until "2023-01-01"        # Logs until date

# Log filtering
journalctl -p err                      # Error level logs
journalctl --grep="pattern"            # Search logs
journalctl -u nginx --since today      # Today's nginx logs
```

**🎯 Real-world Example:** Service Health Monitor

```bash
#!/bin/bash
# service-monitor.sh - Monitor critical services

set -euo pipefail

SERVICES=("nginx" "mysql" "ssh" "fail2ban")
EMAIL_ALERT="admin@example.com"

check_service() {
    local service="$1"
    local status=$(systemctl is-active "$service" 2>/dev/null || echo "inactive")
    
    case $status in
        "active")
            echo "✅ $service - Running"
            return 0
            ;;
        "inactive"|"failed")
            echo "❌ $service - $status"
            return 1
            ;;
        *)
            echo "⚠️ $service - Unknown status: $status"
            return 1
            ;;
    esac
}

restart_service() {
    local service="$1"
    
    echo "🔄 Attempting to restart $service..."
    
    if sudo systemctl restart "$service"; then
        echo "✅ $service restarted successfully"
        
        # Wait a moment and check again
        sleep 5
        if systemctl is-active "$service" >/dev/null; then
            echo "✅ $service is now running"
            return 0
        fi
    fi
    
    echo "❌ Failed to restart $service"
    return 1
}

send_alert() {
    local message="$1"
    
    # Send email (requires mail command)
    if command -v mail >/dev/null; then
        echo "$message" | mail -s "Service Alert" "$EMAIL_ALERT"
    fi
    
    # Log to syslog
    logger -t service-monitor "$message"
}

main() {
    echo "🔍 Service Health Check - $(date)"
    echo "================================"
    
    local failed_services=()
    
    for service in "${SERVICES[@]}"; do
        if ! check_service "$service"; then
            failed_services+=("$service")
        fi
    done
    
    if [[ ${#failed_services[@]} -eq 0 ]]; then
        echo -e "\n✅ All services are running normally"
        exit 0
    fi
    
    echo -e "\n⚠️ Found ${#failed_services[@]} failed service(s)"
    
    for service in "${failed_services[@]}"; do
        echo -e "\n🔧 Handling $service..."
        
        # Show recent logs
        echo "📝 Recent logs:"
        journalctl -u "$service" --since "10 minutes ago" --no-pager -n 5
        
        # Attempt restart
        if restart_service "$service"; then
            echo "✅ $service recovered"
        else
            echo "❌ $service requires manual intervention"
            send_alert "Service $service is down and auto-restart failed"
        fi
    done
}

main "$@"
```

---

## 📊 **Performance Monitoring**

### 📈 **System Performance Tools**

```bash
# CPU monitoring
top                        # Real-time process viewer
htop                       # Enhanced top
nmon                       # Performance monitor
mpstat 1 5                # CPU statistics

# Memory monitoring
free -h                    # Memory usage
vmstat 1 5                # Virtual memory statistics
sar -r 1 5                # Memory usage over time

# Disk I/O monitoring
iostat -x 1 5             # I/O statistics
iotop                     # I/O usage by process
dstat                     # System resource statistics

# Network monitoring
iftop                     # Network bandwidth usage
nethogs                  # Network usage by process
ss -s                    # Socket statistics summary
```

### 🔍 **Process Analysis**

```bash
# Process performance
ps aux --sort=-%cpu | head -10    # Top CPU consumers
ps aux --sort=-%mem | head -10    # Top memory consumers
pidstat -u 1 5                   # Process CPU usage
pidstat -r 1 5                   # Process memory usage

# System calls and library calls
strace -p PID                     # Trace system calls
ltrace -p PID                     # Trace library calls
pmap PID                         # Process memory map
```

### ⚡ **Performance Tuning**

```bash
# Process priority
nice -n -5 command               # High priority
renice -n 10 PID                # Lower priority

# I/O scheduling
ionice -c 1 -n 4 PID            # Real-time I/O class
ionice -c 3 PID                 # Idle I/O class

# System tuning parameters
sysctl -a                       # All kernel parameters
sysctl vm.swappiness            # Check swap tendency
echo 'vm.swappiness=10' >> /etc/sysctl.conf  # Reduce swapping
```

**🎯 Real-world Example:** Performance Report Generator

```bash
#!/bin/bash
# performance-report.sh - Generate comprehensive performance report

set -euo pipefail

REPORT_FILE="/tmp/performance-report-$(date +%Y%m%d-%H%M%S).txt"

header() {
    cat >> "$REPORT_FILE" << EOF
🔍 SYSTEM PERFORMANCE REPORT
============================
Generated: $(date)
Hostname: $(hostname)
Uptime: $(uptime)

EOF
}

cpu_report() {
    cat >> "$REPORT_FILE" << EOF
⚡ CPU INFORMATION
================
$(lscpu | grep -E "^CPU|^Core|^Thread|^Model name|^CPU MHz")

📊 CPU USAGE (5 samples)
$(mpstat 1 5 | tail -1)

🔥 TOP CPU CONSUMERS
$(ps aux --sort=-%cpu | head -6)

EOF
}

memory_report() {
    cat >> "$REPORT_FILE" << EOF
💾 MEMORY INFORMATION
====================
$(free -h)

🔍 MEMORY DETAILS
$(cat /proc/meminfo | grep -E "^MemTotal|^MemFree|^MemAvailable|^Buffers|^Cached|^SwapTotal|^SwapFree")

🔥 TOP MEMORY CONSUMERS
$(ps aux --sort=-%mem | head -6)

EOF
}

disk_report() {
    cat >> "$REPORT_FILE" << EOF
💽 DISK USAGE
=============
$(df -h)

📁 LARGEST DIRECTORIES (top 10)
$(du -sh /* 2>/dev/null | sort -hr | head -10)

⚡ I/O STATISTICS
$(iostat -x 1 1 | tail -n +4)

EOF
}

network_report() {
    cat >> "$REPORT_FILE" << EOF
🌐 NETWORK INFORMATION
======================
🔌 INTERFACES
$(ip addr show | grep -E "^\d+:|inet ")

📊 NETWORK STATISTICS
$(cat /proc/net/dev | grep -v "lo:" | grep ":")

🔍 ACTIVE CONNECTIONS
$(ss -s)

EOF
}

process_report() {
    cat >> "$REPORT_FILE" << EOF
⚙️ PROCESS INFORMATION
======================
📈 PROCESS COUNT: $(ps aux | wc -l)
🏃 RUNNING PROCESSES: $(ps aux | awk '$8 ~ /^R/ {count++} END {print count+0}')
💤 SLEEPING PROCESSES: $(ps aux | awk '$8 ~ /^S/ {count++} END {print count+0}')

🔥 RESOURCE INTENSIVE PROCESSES
$(ps aux --sort=-%cpu,-%mem | head -11)

EOF
}

generate_recommendations() {
    cat >> "$REPORT_FILE" << EOF
💡 PERFORMANCE RECOMMENDATIONS
==============================
EOF

    # Check CPU usage
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%us,//')
    if (( $(echo "$cpu_usage > 80" | bc -l) )); then
        echo "⚠️ High CPU usage detected (${cpu_usage}%). Consider:" >> "$REPORT_FILE"
        echo "  - Identifying resource-intensive processes" >> "$REPORT_FILE"
        echo "  - Optimizing application performance" >> "$REPORT_FILE"
        echo "  - Adding CPU resources" >> "$REPORT_FILE"
    fi

    # Check memory usage
    local mem_usage=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')
    if (( mem_usage > 80 )); then
        echo "⚠️ High memory usage detected (${mem_usage}%). Consider:" >> "$REPORT_FILE"
        echo "  - Identifying memory leaks" >> "$REPORT_FILE"
        echo "  - Optimizing application memory usage" >> "$REPORT_FILE"
        echo "  - Adding RAM" >> "$REPORT_FILE"
    fi

    # Check disk usage
    local disk_usage=$(df / | awk 'NR==2{print $5}' | sed 's/%//')
    if (( disk_usage > 80 )); then
        echo "⚠️ High disk usage detected (${disk_usage}%). Consider:" >> "$REPORT_FILE"
        echo "  - Cleaning up old files and logs" >> "$REPORT_FILE"
        echo "  - Moving data to external storage" >> "$REPORT_FILE"
        echo "  - Adding disk space" >> "$REPORT_FILE"
    fi

    echo "" >> "$REPORT_FILE"
    echo "✅ Report generation completed!" >> "$REPORT_FILE"
}

main() {
    echo "🔍 Generating performance report..."
    
    header
    cpu_report
    memory_report
    disk_report
    network_report
    process_report
    generate_recommendations
    
    echo "✅ Performance report saved to: $REPORT_FILE"
    echo ""
    echo "📊 Quick Summary:"
    echo "  📁 Report File: $REPORT_FILE"
    echo "  💾 Memory Usage: $(free | awk 'NR==2{printf "%.1f%%", $3*100/$2}')"
    echo "  💽 Disk Usage: $(df / | awk 'NR==2{print $5}')"
    echo "  ⚡ Load Average: $(uptime | awk -F'load average:' '{print $2}')"
}

# Check if running as script or being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

---

## 🔒 **System Security Basics**

### 🛡️ **File Permissions & Security**

```bash
# File permissions
ls -la                    # List files with permissions
chmod 755 file           # Change file permissions
chown user:group file    # Change file ownership
umask 022               # Set default permissions

# Special permissions
chmod +s file           # Set SUID bit
chmod +t directory      # Set sticky bit
find / -perm -4000      # Find SUID files (security check)
```

### 🔍 **Security Monitoring**

```bash
# Login monitoring
last                    # Recent logins
lastb                  # Failed login attempts
who -a                 # Currently logged in users

# System integrity
sudo find / -name "*.sh" -perm -002  # World-writable scripts (security risk)
sudo find / -nouser -o -nogroup      # Files without owner
```

### 🚪 **Access Control**

```bash
# SSH security
sudo nano /etc/ssh/sshd_config       # SSH configuration
sudo systemctl reload ssh            # Reload SSH config

# Firewall
sudo ufw status                       # Check firewall status
sudo ufw enable                       # Enable firewall
sudo ufw allow from 192.168.1.0/24   # Allow from specific network
```

---

## 📁 **Advanced File Operations**

### 🔍 **Finding Files**

```bash
# Find command variations
find /path -name "*.txt"              # Find by name
find /path -type f -size +100M        # Find large files
find /path -mtime -7                  # Modified in last 7 days
find /path -user username             # Find by owner

# Advanced find operations
find /path -name "*.log" -exec rm {} \;        # Delete found files
find /path -name "*.txt" -exec grep -l "pattern" {} \;  # Search in files
```

### 📦 **Archive Management**

```bash
# Tar operations
tar -czf archive.tar.gz directory/    # Create compressed archive
tar -xzf archive.tar.gz               # Extract compressed archive
tar -tzf archive.tar.gz               # List archive contents

# Backup with rsync
rsync -avh source/ destination/       # Sync directories
rsync -avh --delete source/ dest/     # Sync with deletions
rsync -avh -e ssh source/ user@host:dest/  # Remote sync
```

### 🔄 **File Synchronization**

```bash
# Watch for file changes
inotifywait -m /path/to/watch         # Monitor file changes
watch -n 5 'ls -la /path'            # Periodically check directory
```

---

## 🛠️ **Troubleshooting Techniques**

### 🔍 **Log Analysis**

```bash
# System logs
sudo tail -f /var/log/syslog          # Follow system log
sudo tail -f /var/log/auth.log        # Follow authentication log
journalctl -f                         # Follow systemd journal

# Application logs
tail -f /var/log/nginx/error.log      # Web server logs
tail -f /var/log/mysql/error.log      # Database logs
```

### 🩺 **System Diagnostics**

```bash
# Hardware diagnostics
dmesg | tail                          # Kernel messages
lspci -v                             # PCI device details
smartctl -a /dev/sda                 # Hard drive health

# Network diagnostics
ping -c 4 8.8.8.8                   # Test connectivity
traceroute google.com                # Network path
nslookup domain.com                  # DNS resolution
```

### 🔧 **Performance Issues**

```bash
# Identify bottlenecks
top -c                               # Show full command lines
iotop -o                            # Show only active I/O
netstat -i                          # Network interface statistics

# Process analysis
strace -p PID                        # Trace system calls
lsof -p PID                         # Show open files
pmap PID                            # Memory mapping
```

**🎯 Real-world Example:** System Health Check Script

```bash
#!/bin/bash
# health-check.sh - Comprehensive system health check

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_disk_space() {
    log_info "Checking disk space usage..."
    
    while read -r line; do
        usage=$(echo "$line" | awk '{print $5}' | sed 's/%//')
        filesystem=$(echo "$line" | awk '{print $6}')
        
        if [[ $usage -gt 90 ]]; then
            log_error "Disk usage critical: $filesystem ($usage%)"
        elif [[ $usage -gt 80 ]]; then
            log_warn "Disk usage high: $filesystem ($usage%)"
        fi
    done < <(df -h | grep -vE '^Filesystem|tmpfs|cdrom')
}

check_memory() {
    log_info "Checking memory usage..."
    
    local mem_usage=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')
    
    if [[ $mem_usage -gt 90 ]]; then
        log_error "Memory usage critical: ${mem_usage}%"
    elif [[ $mem_usage -gt 80 ]]; then
        log_warn "Memory usage high: ${mem_usage}%"
    else
        log_info "Memory usage normal: ${mem_usage}%"
    fi
}

check_load_average() {
    log_info "Checking system load..."
    
    local load=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')
    local cpu_count=$(nproc)
    local load_percent=$(echo "scale=2; $load / $cpu_count * 100" | bc)
    
    if (( $(echo "$load_percent > 80" | bc -l) )); then
        log_error "System load high: $load (${load_percent}% of capacity)"
    else
        log_info "System load normal: $load"
    fi
}

check_services() {
    log_info "Checking critical services..."
    
    local services=("ssh" "networking")
    
    for service in "${services[@]}"; do
        if systemctl is-active --quiet "$service"; then
            log_info "Service $service is running"
        else
            log_error "Service $service is not running"
        fi
    done
}

check_security() {
    log_info "Checking security indicators..."
    
    # Check for failed login attempts
    local failed_logins=$(lastb 2>/dev/null | wc -l)
    if [[ $failed_logins -gt 10 ]]; then
        log_warn "High number of failed login attempts: $failed_logins"
    fi
    
    # Check for world-writable files in critical locations
    local writable_files=$(find /etc /usr/bin /usr/sbin -type f -perm -002 2>/dev/null | wc -l)
    if [[ $writable_files -gt 0 ]]; then
        log_warn "Found $writable_files world-writable files in critical locations"
    fi
}

generate_summary() {
    echo
    log_info "=== HEALTH CHECK SUMMARY ==="
    echo "Date: $(date)"
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime -p)"
    echo "Users: $(who | wc -l) logged in"
    echo "Processes: $(ps aux | wc -l) running"
    echo
}

main() {
    echo "🔍 System Health Check Starting..."
    echo "=================================="
    
    check_disk_space
    check_memory
    check_load_average
    check_services
    check_security
    generate_summary
    
    log_info "✅ Health check completed!"
}

# Check if script is being run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

---

## 🎯 **Practice Exercises**

### 🏋️‍♂️ **Beginner Exercises**

1. **System Information Collection**
   ```bash
   # Create a script that collects and displays:
   # - System information (hostname, kernel version)
   # - Current users
   # - System uptime
   # - Available disk space
   ```

2. **Process Management**
   ```bash
   # Find all processes containing "python" in their name
   # Display their PID, CPU usage, and memory usage
   # Sort by memory usage (highest first)
   ```

### 🏋️‍♀️ **Intermediate Exercises**

3. **Log Analysis**
   ```bash
   # Analyze /var/log/auth.log to find:
   # - Number of successful SSH logins today
   # - Failed login attempts
   # - Most active users
   ```

4. **Disk Space Monitoring**
   ```bash
   # Create a script that:
   # - Monitors disk usage every hour
   # - Sends alert if usage > 80%
   # - Logs the alert to a file
   ```

### 🏋️ **Advanced Exercises**

5. **Performance Monitoring Dashboard**
   ```bash
   # Create a real-time monitoring script that displays:
   # - CPU usage graph
   # - Memory usage
   # - Top 5 processes by CPU/Memory
   # - Network activity
   ```

6. **Automated System Maintenance**
   ```bash
   # Create a comprehensive maintenance script that:
   # - Rotates logs older than 30 days
   # - Cleans temporary files
   # - Updates package cache
   # - Runs security checks
   # - Generates maintenance report
   ```

---

## 🎉 **Congratulations!**

You've completed the Advanced Linux Concepts guide! You now have the knowledge to:

- ✅ Monitor and manage system resources effectively
- ✅ Control processes and services like a pro
- ✅ Understand system performance and optimization
- ✅ Implement basic security practices
- ✅ Troubleshoot common Linux issues

### 🚀 **What's Next?**

1. **Practice**: Set up a test environment and try all the commands
2. **Automate**: Create scripts for common administrative tasks
3. **Learn More**: Dive into [Shell Scripting Guide](./02-shell-scripting-guide.md)
4. **Secure**: Explore [File Permissions & Security](./03-file-permissions-security.md)

---

<div style="background: linear-gradient(90deg, #11998e 0%, #38ef7d 100%); padding: 15px; border-radius: 8px; color: white; text-align: center;">
  <p><strong>🎯 Remember:</strong> The best way to learn Linux is by practicing. Don't be afraid to experiment in a safe environment!</p>
</div>

---

*Happy Linux Administration! 🐧🔧*