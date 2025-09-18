# Comprehensive File Permissions and Security Guide

## Table of Contents
1. [Introduction to Linux Security Model](#introduction-to-linux-security-model)
2. [File Ownership](#file-ownership)
3. [Standard File Permissions](#standard-file-permissions)
4. [Special Permissions](#special-permissions)
5. [Access Control Lists (ACLs)](#access-control-lists-acls)
6. [File Attributes](#file-attributes)
7. [Security Best Practices](#security-best-practices)
8. [Advanced Security Concepts](#advanced-security-concepts)
9. [Troubleshooting Permission Issues](#troubleshooting-permission-issues)
10. [Security Auditing](#security-auditing)
11. [Real-World Examples](#real-world-examples)

## Introduction to Linux Security Model

Linux implements a comprehensive security model based on users, groups, and permissions. This discretionary access control (DAC) system provides the foundation for file system security.

### Security Principles

- **Principle of Least Privilege:** Users and processes should have only the minimum permissions necessary
- **Defense in Depth:** Multiple layers of security controls
- **Fail-Safe Defaults:** Secure by default, deny access unless explicitly granted
- **Complete Mediation:** Every access attempt must be checked
- **Separation of Duties:** Critical operations require multiple authorizations

### Linux Security Components

1. **Users and Groups:** Identity management
2. **File Permissions:** Access control for files and directories
3. **Special Permissions:** Extended access control mechanisms
4. **Access Control Lists (ACLs):** Fine-grained permissions
5. **File Attributes:** Additional file properties
6. **Security Modules:** SELinux, AppArmor, etc.

## File Ownership

Every file and directory in Linux has an owner and a group owner. Understanding ownership is crucial for managing permissions effectively.

### Understanding Ownership

```bash
# View ownership information
ls -l /etc/passwd
# Output: -rw-r--r-- 1 root root 2847 Sep 15 10:30 /etc/passwd
#         │   │   │  │ │    │    │    │           │
#         │   │   │  │ │    │    │    │           └─ filename
#         │   │   │  │ │    │    │    └─ modification time
#         │   │   │  │ │    │    └─ file size
#         │   │   │  │ │    └─ group owner
#         │   │   │  │ └─ user owner
#         │   │   │  └─ number of hard links
#         │   │   └─ permissions for others
#         │   └─ permissions for group
#         └─ permissions for owner

# View ownership with numeric IDs
ls -ln /etc/passwd

# View ownership of directory contents
ls -la /home/
```

### Changing Ownership

```bash
# Change user owner
sudo chown newuser filename
sudo chown newuser /path/to/directory

# Change group owner
sudo chgrp newgroup filename
sudo chown :newgroup filename

# Change both user and group
sudo chown newuser:newgroup filename
sudo chown newuser. filename  # Changes to user's primary group

# Recursive ownership change
sudo chown -R user:group /path/to/directory

# Only change files that are currently owned by specific user
sudo chown --from=olduser newuser filename

# Reference another file's ownership
sudo chown --reference=reference_file target_file
```

### Advanced Ownership Operations

```bash
#!/bin/bash

# Function to safely change ownership
safe_chown() {
    local target=$1
    local new_owner=$2
    local backup_info="/tmp/ownership_backup_$(date +%s)"
    
    echo "Backing up current ownership..."
    find "$target" -printf "%p %u:%g\n" > "$backup_info"
    
    echo "Changing ownership to $new_owner..."
    if chown -R "$new_owner" "$target"; then
        echo "Ownership changed successfully"
        echo "Backup information saved to: $backup_info"
    else
        echo "Failed to change ownership" >&2
        return 1
    fi
}

# Function to restore ownership from backup
restore_ownership() {
    local backup_file=$1
    
    while IFS=' ' read -r file owner; do
        if [ -e "$file" ]; then
            chown "$owner" "$file"
            echo "Restored: $file -> $owner"
        fi
    done < "$backup_file"
}

# Find files owned by specific user
find_user_files() {
    local username=$1
    local search_path=${2:-/}
    
    echo "Finding files owned by $username in $search_path..."
    find "$search_path" -user "$username" -ls 2>/dev/null
}

# Find orphaned files (no valid owner)
find_orphaned_files() {
    local search_path=${1:-/}
    
    echo "Finding orphaned files in $search_path..."
    find "$search_path" -nouser -o -nogroup 2>/dev/null
}
```

## Standard File Permissions

File permissions determine what actions can be performed on a file and by whom. There are three types of permissions applied to three categories of users.

### Permission Types

1. **Read (r):** 
   - Files: View contents
   - Directories: List contents (requires execute permission too)

2. **Write (w):**
   - Files: Modify contents
   - Directories: Create, delete, rename files (requires execute permission too)

3. **Execute (x):**
   - Files: Run as program
   - Directories: Enter/traverse directory

### User Categories

1. **User/Owner (u):** The file owner
2. **Group (g):** Members of the file's group
3. **Others (o):** Everyone else
4. **All (a):** All categories combined

### Viewing Permissions in Detail

```bash
# Detailed permission breakdown
analyze_permissions() {
    local file=$1
    
    if [ ! -e "$file" ]; then
        echo "File not found: $file"
        return 1
    fi
    
    local perms=$(ls -ld "$file" | cut -d' ' -f1)
    local filetype=${perms:0:1}
    local user_perms=${perms:1:3}
    local group_perms=${perms:4:3}
    local other_perms=${perms:7:3}
    
    echo "File: $file"
    echo "Full permissions: $perms"
    echo
    
    # File type
    case $filetype in
        '-') echo "Type: Regular file" ;;
        'd') echo "Type: Directory" ;;
        'l') echo "Type: Symbolic link" ;;
        'c') echo "Type: Character device" ;;
        'b') echo "Type: Block device" ;;
        'p') echo "Type: Named pipe (FIFO)" ;;
        's') echo "Type: Socket" ;;
        *) echo "Type: Unknown ($filetype)" ;;
    esac
    
    echo
    echo "User permissions:  $user_perms"
    echo "Group permissions: $group_perms"
    echo "Other permissions: $other_perms"
    echo
    
    # Detailed breakdown
    echo "Detailed breakdown:"
    decode_permission_set "User" "$user_perms"
    decode_permission_set "Group" "$group_perms"
    decode_permission_set "Others" "$other_perms"
}

decode_permission_set() {
    local category=$1
    local perms=$2
    
    local r=${perms:0:1}
    local w=${perms:1:1}
    local x=${perms:2:1}
    
    printf "%-8s: " "$category"
    
    [ "$r" = "r" ] && printf "Read " || printf "---- "
    [ "$w" = "w" ] && printf "Write " || printf "----- "
    [ "$x" = "x" ] && printf "Execute" || printf "-------"
    
    echo
}
```

### Changing Permissions

#### Symbolic Mode

```bash
# Grant permissions
chmod u+r file          # Add read for user
chmod g+w file          # Add write for group
chmod o+x file          # Add execute for others
chmod a+x file          # Add execute for all

# Remove permissions
chmod u-w file          # Remove write for user
chmod g-r file          # Remove read for group
chmod o-x file          # Remove execute for others

# Set exact permissions
chmod u=rwx file        # User: read, write, execute
chmod g=r-x file        # Group: read, execute (no write)
chmod o=--- file        # Others: no permissions

# Combine operations
chmod u+x,g-w,o=r file  # Multiple operations
chmod a+r,u+w file      # Add read for all, write for user

# Copy permissions from another category
chmod g=u file          # Set group permissions same as user
chmod o=g file          # Set others permissions same as group
```

#### Octal (Numeric) Mode

```bash
# Common permission combinations
chmod 755 file    # rwxr-xr-x (executable, readable by all)
chmod 644 file    # rw-r--r-- (readable by all, writable by owner)
chmod 600 file    # rw------- (private file)
chmod 700 dir     # rwx------ (private directory)
chmod 750 dir     # rwxr-x--- (group-accessible directory)
chmod 777 file    # rwxrwxrwx (all permissions - dangerous!)

# Understanding octal calculation
# r (read)    = 4
# w (write)   = 2
# x (execute) = 1
# 
# Examples:
# rwx = 4+2+1 = 7
# r-x = 4+0+1 = 5
# r-- = 4+0+0 = 4
# -w- = 0+2+0 = 2
```

#### Advanced Permission Operations

```bash
# Set permissions recursively with different rules for files and directories
find /path/to/directory -type f -exec chmod 644 {} \;  # Files: rw-r--r--
find /path/to/directory -type d -exec chmod 755 {} \;  # Directories: rwxr-xr-x

# Set permissions based on existing permissions
chmod a+X file    # Add execute only if file is already executable or is directory

# Conditional permissions
chmod u+w file 2>/dev/null || echo "Cannot modify permissions"

# Function to set secure permissions
set_secure_permissions() {
    local path=$1
    local file_perms=${2:-644}
    local dir_perms=${3:-755}
    
    if [ -d "$path" ]; then
        echo "Setting permissions for directory structure: $path"
        find "$path" -type f -exec chmod "$file_perms" {} \;
        find "$path" -type d -exec chmod "$dir_perms" {} \;
        echo "Permissions set: files=$file_perms, directories=$dir_perms"
    elif [ -f "$path" ]; then
        chmod "$file_perms" "$path"
        echo "File permissions set to $file_perms"
    else
        echo "Path not found: $path" >&2
        return 1
    fi
}
```

## Special Permissions

Special permissions provide additional access control mechanisms beyond standard read, write, and execute permissions.

### Setuid (SUID) - Set User ID

When the setuid bit is set on an executable file, it runs with the privileges of the file owner rather than the user executing it.

```bash
# Set SUID bit
chmod u+s /usr/bin/passwd
chmod 4755 /usr/bin/passwd  # 4 = SUID bit

# View SUID files
find /usr -perm -4000 -ls 2>/dev/null

# Example of SUID usage
ls -l /usr/bin/passwd
# -rwsr-xr-x 1 root root 59640 Jan 25  2018 /usr/bin/passwd
#    ^
#    SUID bit (s instead of x)

# Security implications
echo "SUID files are potential security risks:"
find / -perm -4000 -type f 2>/dev/null | head -10
```

### Setgid (SGID) - Set Group ID

#### On Executable Files

```bash
# Set SGID on executable
chmod g+s /usr/bin/wall
chmod 2755 /usr/bin/wall   # 2 = SGID bit

# Find SGID executables
find /usr -perm -2000 -type f 2>/dev/null
```

#### On Directories

When set on a directory, new files created within inherit the directory's group ownership.

```bash
# Create shared directory with SGID
mkdir /shared/project
chmod g+s /shared/project
chmod 2775 /shared/project

# Test SGID behavior
cd /shared/project
touch newfile
ls -l newfile  # Should show group ownership from parent directory

# Function to create collaborative directory
create_shared_directory() {
    local dir_path=$1
    local group_name=$2
    
    # Create directory
    mkdir -p "$dir_path"
    
    # Set group ownership
    chgrp "$group_name" "$dir_path"
    
    # Set SGID bit and appropriate permissions
    chmod 2775 "$dir_path"
    
    echo "Created shared directory: $dir_path"
    echo "Group: $group_name"
    echo "New files will inherit group ownership"
}
```

### Sticky Bit

The sticky bit prevents users from deleting files they don't own in a directory, even if they have write permission to the directory.

```bash
# Set sticky bit
chmod +t /tmp
chmod 1777 /tmp  # 1 = sticky bit

# View directories with sticky bit
find / -perm -1000 -type d 2>/dev/null

# Example: /tmp directory
ls -ld /tmp
# drwxrwxrwt 15 root root 4096 Sep 18 10:30 /tmp
#         ^
#         sticky bit (t instead of x)

# Create directory with sticky bit
mkdir shared_temp
chmod 1777 shared_temp

# Test sticky bit behavior
sudo -u user1 touch shared_temp/user1_file
sudo -u user2 touch shared_temp/user2_file
# user1 cannot delete user2_file even with directory write permission
```

### Combining Special Permissions

```bash
# All special bits set
chmod 7755 file  # SUID + SGID + Sticky

# Check for files with special permissions
find_special_permissions() {
    local search_path=${1:-/}
    
    echo "Files with SUID bit:"
    find "$search_path" -perm -4000 -type f 2>/dev/null | head -5
    
    echo -e "\nFiles with SGID bit:"
    find "$search_path" -perm -2000 -type f 2>/dev/null | head -5
    
    echo -e "\nDirectories with SGID bit:"
    find "$search_path" -perm -2000 -type d 2>/dev/null | head -5
    
    echo -e "\nDirectories with sticky bit:"
    find "$search_path" -perm -1000 -type d 2>/dev/null | head -5
}
```

## Access Control Lists (ACLs)

ACLs provide fine-grained permission control beyond the traditional user-group-other model.

### ACL Basics

```bash
# Check if filesystem supports ACLs
mount | grep acl

# Enable ACLs on filesystem (if not enabled)
sudo mount -o remount,acl /

# View ACLs
getfacl filename
getfacl directory/

# Set ACL for specific user
setfacl -m u:username:rwx filename
setfacl -m u:alice:r-x /path/to/file

# Set ACL for specific group
setfacl -m g:groupname:rw- filename

# Set default ACLs for directories
setfacl -d -m u:alice:rwx directory/
setfacl -d -m g:developers:rw- directory/

# Remove ACL entries
setfacl -x u:alice filename
setfacl -x g:developers filename

# Remove all ACLs
setfacl -b filename
```

### Advanced ACL Operations

```bash
#!/bin/bash

# Function to set up project directory with ACLs
setup_project_directory() {
    local project_dir=$1
    local project_group=$2
    local read_only_users=$3  # comma-separated list
    local read_write_users=$4 # comma-separated list
    
    # Create directory
    mkdir -p "$project_dir"
    
    # Set basic permissions and group
    chmod 750 "$project_dir"
    chgrp "$project_group" "$project_dir"
    
    # Set default ACLs for the directory
    setfacl -d -m g:"$project_group":rwx "$project_dir"
    setfacl -d -m o::--- "$project_dir"
    
    # Add read-only users
    IFS=',' read -ra RO_USERS <<< "$read_only_users"
    for user in "${RO_USERS[@]}"; do
        setfacl -m u:"$user":r-x "$project_dir"
        setfacl -d -m u:"$user":r-x "$project_dir"
        echo "Added read-only access for user: $user"
    done
    
    # Add read-write users
    IFS=',' read -ra RW_USERS <<< "$read_write_users"
    for user in "${RW_USERS[@]}"; do
        setfacl -m u:"$user":rwx "$project_dir"
        setfacl -d -m u:"$user":rwx "$project_dir"
        echo "Added read-write access for user: $user"
    done
    
    echo "Project directory setup complete: $project_dir"
    getfacl "$project_dir"
}

# Function to copy ACLs from one file to another
copy_acls() {
    local source=$1
    local target=$2
    
    if [ ! -e "$source" ]; then
        echo "Source file not found: $source" >&2
        return 1
    fi
    
    if [ ! -e "$target" ]; then
        echo "Target file not found: $target" >&2
        return 1
    fi
    
    # Get ACLs from source and apply to target
    getfacl "$source" | setfacl --set-file=- "$target"
    echo "ACLs copied from $source to $target"
}

# Function to audit ACL usage
audit_acls() {
    local search_path=${1:-/home}
    
    echo "Auditing ACL usage in: $search_path"
    echo "======================================="
    
    # Find files with ACLs
    find "$search_path" -type f -exec getfacl --skip-base {} \; 2>/dev/null | \
    grep -B1 "user:" | grep "^# file:" | sort | uniq
    
    echo -e "\nDirectories with default ACLs:"
    find "$search_path" -type d -exec getfacl --skip-base {} \; 2>/dev/null | \
    grep -B1 "default:user:" | grep "^# file:" | sort | uniq
}
```

## File Attributes

Linux provides additional file attributes that complement standard permissions.

### Extended Attributes (xattr)

```bash
# View extended attributes
lsattr filename
getfattr -d filename

# Set extended attributes
chattr +i filename    # Make immutable
chattr +a filename    # Append-only
chattr +u filename    # Undeletable
chattr +s filename    # Secure deletion
chattr +c filename    # Compressed

# Remove extended attributes
chattr -i filename
chattr -a filename

# Common attribute combinations
chattr +ai filename   # Append-only and immutable

# Set custom extended attributes
setfattr -n user.description -v "Important file" filename
setfattr -n user.author -v "admin" filename

# View custom attributes
getfattr -n user.description filename
getfattr --dump filename
```

### Advanced File Attribute Management

```bash
#!/bin/bash

# Function to protect critical files
protect_critical_files() {
    local files=("$@")
    
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            # Make immutable
            chattr +i "$file"
            
            # Add metadata
            setfattr -n user.protected_date -v "$(date)" "$file"
            setfattr -n user.protected_by -v "$USER" "$file"
            
            echo "Protected: $file"
        else
            echo "Warning: File not found: $file"
        fi
    done
}

# Function to create secure log file
create_secure_log() {
    local log_file=$1
    
    # Create file
    touch "$log_file"
    
    # Set permissions (owner read/write, group read, no others)
    chmod 640 "$log_file"
    
    # Make append-only
    chattr +a "$log_file"
    
    # Add metadata
    setfattr -n user.log_type -v "secure" "$log_file"
    setfattr -n user.created_date -v "$(date)" "$log_file"
    
    echo "Secure log file created: $log_file"
    echo "File can only be appended to, not modified or deleted"
}

# Function to audit file attributes
audit_file_attributes() {
    local search_path=${1:-"."}
    
    echo "File Attribute Audit Report"
    echo "=========================="
    echo "Path: $search_path"
    echo "Date: $(date)"
    echo
    
    # Find files with special attributes
    echo "Files with immutable attribute (+i):"
    find "$search_path" -type f -exec lsattr {} \; 2>/dev/null | grep "i" | head -10
    
    echo -e "\nFiles with append-only attribute (+a):"
    find "$search_path" -type f -exec lsattr {} \; 2>/dev/null | grep "a" | head -10
    
    echo -e "\nFiles with custom extended attributes:"
    find "$search_path" -type f -exec getfattr --dump {} \; 2>/dev/null | grep -B1 "user\." | head -10
}
```

## Security Best Practices

### Permission Hardening

```bash
#!/bin/bash

# System hardening script
harden_system_permissions() {
    echo "Starting system permission hardening..."
    
    # Secure /tmp directory
    if [ -d "/tmp" ]; then
        chmod 1777 /tmp
        echo "✓ Secured /tmp directory"
    fi
    
    # Secure /var/tmp directory
    if [ -d "/var/tmp" ]; then
        chmod 1777 /var/tmp
        echo "✓ Secured /var/tmp directory"
    fi
    
    # Secure home directories
    for home_dir in /home/*; do
        if [ -d "$home_dir" ]; then
            chmod 750 "$home_dir"
            echo "✓ Secured home directory: $home_dir"
        fi
    done
    
    # Find and report world-writable files
    echo "Scanning for world-writable files..."
    find / -type f -perm -002 ! -path "/proc/*" ! -path "/sys/*" 2>/dev/null | head -10
    
    # Find and report SUID/SGID files
    echo "Auditing SUID/SGID files..."
    find / -type f \( -perm -4000 -o -perm -2000 \) ! -path "/proc/*" 2>/dev/null | head -10
}

# Function to set secure default permissions for new files
set_secure_umask() {
    local umask_value=${1:-022}
    
    echo "Setting secure umask: $umask_value"
    umask "$umask_value"
    
    # Add to shell profile
    echo "umask $umask_value" >> ~/.bashrc
    
    echo "New files will be created with secure permissions"
    echo "Files: $((666 - $umask_value))"
    echo "Directories: $((777 - $umask_value))"
}

# Function to audit weak permissions
audit_weak_permissions() {
    local search_path=${1:-/}
    
    echo "Security Audit Report"
    echo "===================="
    echo "Date: $(date)"
    echo "Path: $search_path"
    echo
    
    # World-writable files
    echo "CRITICAL: World-writable files:"
    find "$search_path" -type f -perm -002 ! -path "/proc/*" ! -path "/sys/*" 2>/dev/null
    
    # World-writable directories without sticky bit
    echo -e "\nWARNING: World-writable directories without sticky bit:"
    find "$search_path" -type d -perm -002 ! -perm -1000 ! -path "/proc/*" ! -path "/sys/*" 2>/dev/null
    
    # Files with excessive permissions
    echo -e "\nWARNING: Files with 777 permissions:"
    find "$search_path" -type f -perm 777 2>/dev/null
    
    # SUID/SGID files
    echo -e "\nINFO: SUID files:"
    find "$search_path" -type f -perm -4000 2>/dev/null | head -5
    
    echo -e "\nINFO: SGID files:"
    find "$search_path" -type f -perm -2000 2>/dev/null | head -5
}
```

### User and Group Management Security

```bash
#!/bin/bash

# Secure user creation function
create_secure_user() {
    local username=$1
    local full_name=$2
    local groups=$3
    
    if id "$username" &>/dev/null; then
        echo "User $username already exists" >&2
        return 1
    fi
    
    # Create user with secure defaults
    useradd -m -s /bin/bash -c "$full_name" "$username"
    
    # Set secure home directory permissions
    chmod 750 "/home/$username"
    
    # Add to specified groups
    if [ -n "$groups" ]; then
        usermod -a -G "$groups" "$username"
    fi
    
    # Force password change on first login
    passwd -e "$username"
    
    # Set password aging
    chage -M 90 -W 7 "$username"  # Max 90 days, warn 7 days before
    
    echo "Secure user created: $username"
    echo "Home directory: /home/$username (permissions: 750)"
    echo "Groups: $(groups $username)"
}

# Function to audit user permissions
audit_user_security() {
    echo "User Security Audit"
    echo "=================="
    
    # Check for users with UID 0
    echo "Users with UID 0 (root privileges):"
    awk -F: '$3 == 0 {print $1}' /etc/passwd
    
    # Check for users with empty passwords
    echo -e "\nUsers with empty passwords:"
    awk -F: '($2 == "" || $2 == "!!" || $2 == "*") {print $1}' /etc/shadow 2>/dev/null || echo "Cannot read /etc/shadow"
    
    # Check for users with non-standard shells
    echo -e "\nUsers with non-standard shells:"
    awk -F: '$7 !~ /\/(bash|sh|zsh|fish|csh|tcsh|nologin|false)$/ {print $1 ": " $7}' /etc/passwd
    
    # Check for orphaned home directories
    echo -e "\nOrphaned home directories:"
    for home in /home/*; do
        if [ -d "$home" ]; then
            username=$(basename "$home")
            if ! id "$username" &>/dev/null; then
                echo "Orphaned: $home (user $username does not exist)"
            fi
        fi
    done
}
```

This comprehensive guide covers advanced file permissions, security concepts, and best practices for maintaining a secure Linux system. Regular auditing and proper permission management are essential for system security.

## Advanced Security Concepts

### SELinux (Security-Enhanced Linux)

SELinux provides mandatory access control (MAC) as an additional layer of security.

```bash
# Check SELinux status
sestatus
getenforce

# View SELinux context
ls -Z /etc/passwd
ps -Z

# Set SELinux contexts
chcon -t httpd_exec_t /usr/local/bin/webapp
semanage fcontext -a -t httpd_exec_t "/usr/local/bin/webapp"

# SELinux boolean settings
getsebool -a | grep httpd
setsebool -P httpd_can_network_connect on

# SELinux troubleshooting
ausearch -m avc -ts recent
sealert -a /var/log/audit/audit.log
```

### AppArmor

AppArmor provides application-level security through profiles.

```bash
# Check AppArmor status
aa-status
apparmor_status

# Load/unload profiles
aa-enforce /etc/apparmor.d/usr.bin.firefox
aa-complain /etc/apparmor.d/usr.bin.firefox
aa-disable /etc/apparmor.d/usr.bin.firefox

# Generate new profile
aa-genprof /usr/local/bin/myapp

# Profile management
aa-autodep program_name
aa-logprof
```

### Capabilities

Linux capabilities provide fine-grained privilege control.

```bash
# View file capabilities
getcap /usr/bin/ping
getcap -r /usr 2>/dev/null

# Set capabilities
setcap cap_net_raw+ep /usr/local/bin/myping

# Remove capabilities
setcap -r /usr/local/bin/myping

# Process capabilities
grep Cap /proc/self/status

# Common capabilities
# CAP_NET_RAW: raw socket operations
# CAP_NET_ADMIN: network administration
# CAP_SYS_ADMIN: system administration
# CAP_DAC_OVERRIDE: override file permissions
```

## Troubleshooting Permission Issues

### Common Permission Problems

```bash
#!/bin/bash

# Permission troubleshooting toolkit
diagnose_permissions() {
    local target=$1
    
    echo "Permission Diagnosis for: $target"
    echo "================================="
    
    if [ ! -e "$target" ]; then
        echo "❌ Target does not exist"
        return 1
    fi
    
    # Basic information
    echo "Basic Information:"
    ls -ld "$target"
    
    # Ownership
    local owner=$(stat -c %U "$target")
    local group=$(stat -c %G "$target")
    echo "Owner: $owner"
    echo "Group: $group"
    echo "Current user: $USER"
    echo "Current groups: $(groups)"
    
    # Access tests
    echo -e "\nAccess Tests:"
    test_access "read" "-r" "$target"
    test_access "write" "-w" "$target"
    test_access "execute" "-x" "$target"
    
    # ACLs
    if command -v getfacl >/dev/null 2>&1; then
        echo -e "\nACL Information:"
        getfacl "$target" 2>/dev/null || echo "No ACLs or not supported"
    fi
    
    # Attributes
    if command -v lsattr >/dev/null 2>&1; then
        echo -e "\nFile Attributes:"
        lsattr "$target" 2>/dev/null || echo "Cannot read attributes"
    fi
    
    # SELinux context
    if command -v ls >/dev/null 2>&1 && ls --help | grep -q '\--context'; then
        echo -e "\nSELinux Context:"
        ls -Z "$target" 2>/dev/null || echo "SELinux not available"
    fi
    
    # Parent directory permissions (if file)
    if [ -f "$target" ]; then
        local parent_dir=$(dirname "$target")
        echo -e "\nParent Directory Permissions:"
        ls -ld "$parent_dir"
        test_access "execute on parent" "-x" "$parent_dir"
    fi
}

test_access() {
    local test_name=$1
    local test_flag=$2
    local target=$3
    
    if [ $test_flag "$target" ]; then
        echo "✅ $test_name: allowed"
    else
        echo "❌ $test_name: denied"
    fi
}

# Function to fix common permission issues
fix_common_issues() {
    local target=$1
    local fix_type=${2:-auto}
    
    echo "Attempting to fix common permission issues for: $target"
    
    if [ ! -e "$target" ]; then
        echo "Target does not exist: $target"
        return 1
    fi
    
    case $fix_type in
        "web")
            # Web server files
            if [ -f "$target" ]; then
                chmod 644 "$target"
                echo "Set web file permissions: 644"
            elif [ -d "$target" ]; then
                find "$target" -type f -exec chmod 644 {} \;
                find "$target" -type d -exec chmod 755 {} \;
                echo "Set web directory permissions: files 644, directories 755"
            fi
            ;;
        "script")
            # Executable scripts
            chmod 755 "$target"
            echo "Set script permissions: 755"
            ;;
        "private")
            # Private files
            if [ -f "$target" ]; then
                chmod 600 "$target"
                echo "Set private file permissions: 600"
            elif [ -d "$target" ]; then
                chmod 700 "$target"
                echo "Set private directory permissions: 700"
            fi
            ;;
        "auto")
            # Automatic detection and fix
            if [ -x "$target" ] || [[ "$target" == *.sh ]]; then
                chmod 755 "$target"
                echo "Detected executable, set permissions: 755"
            elif [ -f "$target" ]; then
                chmod 644 "$target"
                echo "Set file permissions: 644"
            elif [ -d "$target" ]; then
                chmod 755 "$target"
                echo "Set directory permissions: 755"
            fi
            ;;
    esac
}

# Function to resolve ownership issues
fix_ownership_issues() {
    local target=$1
    local new_owner=${2:-$USER}
    local new_group=${3:-$(id -gn)}
    
    echo "Fixing ownership for: $target"
    echo "New owner: $new_owner:$new_group"
    
    if [ -O "$target" ] || [ "$EUID" -eq 0 ]; then
        chown -R "$new_owner:$new_group" "$target"
        echo "Ownership changed successfully"
    else
        echo "Error: Insufficient permissions to change ownership"
        echo "Try running with sudo or as the file owner"
        return 1
    fi
}
```

## Security Auditing

### Comprehensive Security Audit

```bash
#!/bin/bash

# Complete system security audit
security_audit() {
    local report_file="security_audit_$(date +%Y%m%d_%H%M%S).txt"
    
    {
        echo "Linux Security Audit Report"
        echo "==========================="
        echo "Date: $(date)"
        echo "System: $(uname -a)"
        echo "User: $USER"
        echo
        
        # File permission issues
        echo "1. FILE PERMISSION ISSUES"
        echo "=========================="
        
        echo "World-writable files:"
        find / -type f -perm -002 ! -path "/proc/*" ! -path "/sys/*" ! -path "/dev/*" 2>/dev/null | head -20
        
        echo -e "\nWorld-writable directories without sticky bit:"
        find / -type d -perm -002 ! -perm -1000 ! -path "/proc/*" ! -path "/sys/*" ! -path "/dev/*" 2>/dev/null | head -10
        
        echo -e "\nFiles with 777 permissions:"
        find / -type f -perm 777 ! -path "/proc/*" ! -path "/sys/*" ! -path "/dev/*" 2>/dev/null | head -10
        
        # SUID/SGID analysis
        echo -e "\n2. SUID/SGID ANALYSIS"
        echo "====================="
        
        echo "SUID files:"
        find / -type f -perm -4000 ! -path "/proc/*" ! -path "/sys/*" 2>/dev/null | head -20
        
        echo -e "\nSGID files:"
        find / -type f -perm -2000 ! -path "/proc/*" ! -path "/sys/*" 2>/dev/null | head -20
        
        # User account analysis
        echo -e "\n3. USER ACCOUNT ANALYSIS"
        echo "========================"
        
        echo "Users with UID 0:"
        awk -F: '$3 == 0 {print $1 " (UID: " $3 ")"}' /etc/passwd
        
        echo -e "\nUsers with empty passwords:"
        awk -F: '$2 == "" {print $1}' /etc/shadow 2>/dev/null | head -5
        
        echo -e "\nUsers with no login shell restrictions:"
        awk -F: '$7 !~ /(nologin|false)$/ && $3 >= 1000 {print $1 " (Shell: " $7 ")"}' /etc/passwd
        
        # Home directory permissions
        echo -e "\n4. HOME DIRECTORY ANALYSIS"
        echo "=========================="
        
        echo "Insecure home directory permissions:"
        for home in /home/*; do
            if [ -d "$home" ]; then
                perms=$(stat -c %a "$home")
                if [ "$perms" -gt 750 ]; then
                    echo "$home (permissions: $perms)"
                fi
            fi
        done
        
        # System file integrity
        echo -e "\n5. SYSTEM FILE INTEGRITY"
        echo "========================"
        
        echo "Modified system files (last 7 days):"
        find /etc /usr/bin /usr/sbin -type f -mtime -7 2>/dev/null | head -10
        
        # Log file analysis
        echo -e "\n6. LOG ANALYSIS"
        echo "==============="
        
        echo "Recent authentication failures:"
        grep -i "authentication failure" /var/log/auth.log 2>/dev/null | tail -5 || echo "No auth.log or no failures found"
        
        echo -e "\nRecent sudo usage:"
        grep "sudo:" /var/log/auth.log 2>/dev/null | tail -5 || echo "No sudo usage found"
        
        # Network security
        echo -e "\n7. NETWORK SECURITY"
        echo "==================="
        
        echo "Open ports:"
        ss -tlnp 2>/dev/null | head -10 || netstat -tlnp 2>/dev/null | head -10 || echo "Cannot determine open ports"
        
        # Process analysis
        echo -e "\n8. PROCESS ANALYSIS"
        echo "==================="
        
        echo "Processes running as root:"
        ps aux | awk '$1 == "root" {print $11}' | sort | uniq -c | sort -rn | head -10
        
    } > "$report_file"
    
    echo "Security audit complete. Report saved to: $report_file"
    
    # Display summary
    echo -e "\nSECURITY AUDIT SUMMARY"
    echo "======================"
    
    local world_writable=$(find / -type f -perm -002 ! -path "/proc/*" ! -path "/sys/*" ! -path "/dev/*" 2>/dev/null | wc -l)
    local suid_files=$(find / -type f -perm -4000 ! -path "/proc/*" ! -path "/sys/*" 2>/dev/null | wc -l)
    local root_users=$(awk -F: '$3 == 0' /etc/passwd | wc -l)
    
    echo "World-writable files: $world_writable"
    echo "SUID files: $suid_files"
    echo "Users with root privileges: $root_users"
    
    if [ "$world_writable" -gt 10 ] || [ "$suid_files" -gt 50 ] || [ "$root_users" -gt 2 ]; then
        echo "⚠️  WARNING: Security issues detected. Review the full report."
    else
        echo "✅ No major security issues detected."
    fi
}

# Function for continuous monitoring
setup_security_monitoring() {
    local monitor_script="/usr/local/bin/security_monitor.sh"
    local log_file="/var/log/security_monitor.log"
    
    # Create monitoring script
    cat > "$monitor_script" << 'EOF'
#!/bin/bash

LOG_FILE="/var/log/security_monitor.log"

log_event() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Monitor for new SUID files
current_suid=$(find / -type f -perm -4000 2>/dev/null | sort)
if [ -f "/tmp/known_suid.txt" ]; then
    if ! diff -q <(echo "$current_suid") /tmp/known_suid.txt >/dev/null; then
        log_event "WARNING: New SUID files detected"
        diff <(echo "$current_suid") /tmp/known_suid.txt >> "$LOG_FILE"
    fi
fi
echo "$current_suid" > /tmp/known_suid.txt

# Monitor for world-writable files in sensitive locations
world_writable=$(find /etc /usr/bin /usr/sbin -type f -perm -002 2>/dev/null)
if [ -n "$world_writable" ]; then
    log_event "CRITICAL: World-writable files in sensitive locations"
    echo "$world_writable" >> "$LOG_FILE"
fi

# Monitor for failed login attempts
failed_logins=$(grep "authentication failure" /var/log/auth.log 2>/dev/null | grep "$(date '+%b %d')" | wc -l)
if [ "$failed_logins" -gt 10 ]; then
    log_event "WARNING: High number of failed login attempts: $failed_logins"
fi
EOF

    chmod +x "$monitor_script"
    
    # Add to crontab for hourly execution
    (crontab -l 2>/dev/null; echo "0 * * * * $monitor_script") | crontab -
    
    echo "Security monitoring setup complete"
    echo "Monitor script: $monitor_script"
    echo "Log file: $log_file"
    echo "Runs hourly via cron"
}
```

## Real-World Examples

### Web Server Security Setup

```bash
#!/bin/bash

# Secure web server directory setup
setup_web_security() {
    local web_root="/var/www/html"
    local web_user="www-data"
    local admin_group="webadmins"
    
    echo "Setting up secure web server permissions..."
    
    # Create admin group if it doesn't exist
    getent group "$admin_group" >/dev/null || groupadd "$admin_group"
    
    # Set directory ownership and permissions
    chown -R "$web_user:$admin_group" "$web_root"
    
    # Set secure permissions
    find "$web_root" -type d -exec chmod 755 {} \;  # Directories
    find "$web_root" -type f -exec chmod 644 {} \;  # Files
    
    # Make scripts executable
    find "$web_root" -name "*.php" -exec chmod 644 {} \;
    find "$web_root" -name "*.cgi" -exec chmod 755 {} \;
    find "$web_root" -name "*.pl" -exec chmod 755 {} \;
    
    # Secure upload directories
    if [ -d "$web_root/uploads" ]; then
        chmod 755 "$web_root/uploads"
        # Prevent execution in uploads
        echo "Options -ExecCGI -Indexes" > "$web_root/uploads/.htaccess"
        chmod 644 "$web_root/uploads/.htaccess"
    fi
    
    # Set up ACLs for admin access
    setfacl -R -m g:"$admin_group":rw- "$web_root"
    setfacl -R -d -m g:"$admin_group":rw- "$web_root"
    
    echo "Web server security setup complete"
}

# Database security setup
setup_database_security() {
    local db_data_dir="/var/lib/mysql"
    local db_user="mysql"
    local backup_dir="/var/backups/mysql"
    
    echo "Setting up database security..."
    
    # Secure data directory
    chown -R "$db_user:$db_user" "$db_data_dir"
    chmod 700 "$db_data_dir"
    
    # Secure configuration files
    chown root:root /etc/mysql/my.cnf
    chmod 644 /etc/mysql/my.cnf
    
    # Secure backup directory
    mkdir -p "$backup_dir"
    chown "$db_user:$db_user" "$backup_dir"
    chmod 700 "$backup_dir"
    
    # Set up log file permissions
    touch /var/log/mysql/error.log
    chown "$db_user:adm" /var/log/mysql/error.log
    chmod 640 /var/log/mysql/error.log
    
    echo "Database security setup complete"
}

# Application deployment security
deploy_application_securely() {
    local app_name=$1
    local app_dir="/opt/$app_name"
    local app_user="$app_name"
    local app_group="$app_name"
    
    echo "Deploying application securely: $app_name"
    
    # Create application user and group
    getent group "$app_group" >/dev/null || groupadd "$app_group"
    getent passwd "$app_user" >/dev/null || useradd -r -g "$app_group" -s /bin/false -d "$app_dir" "$app_user"
    
    # Create and secure application directory
    mkdir -p "$app_dir"
    chown "$app_user:$app_group" "$app_dir"
    chmod 750 "$app_dir"
    
    # Set up application subdirectories
    mkdir -p "$app_dir"/{bin,config,data,logs,tmp}
    
    # Set appropriate permissions
    chown -R "$app_user:$app_group" "$app_dir"
    chmod 755 "$app_dir/bin"
    chmod 750 "$app_dir/config"
    chmod 700 "$app_dir/data"
    chmod 755 "$app_dir/logs"
    chmod 700 "$app_dir/tmp"
    
    # Secure configuration files
    find "$app_dir/config" -type f -exec chmod 640 {} \;
    
    # Make binaries executable
    find "$app_dir/bin" -type f -exec chmod 755 {} \;
    
    # Set up log rotation
    cat > "/etc/logrotate.d/$app_name" << EOF
$app_dir/logs/*.log {
    daily
    missingok
    rotate 52
    compress
    delaycompress
    notifempty
    create 644 $app_user $app_group
}
EOF
    
    echo "Application deployment complete"
    echo "User: $app_user"
    echo "Directory: $app_dir"
    echo "Permissions configured for security"
}
```

This comprehensive guide provides detailed coverage of Linux file permissions, security concepts, and practical implementation strategies. Regular practice and application of these concepts will help maintain a secure Linux environment.
