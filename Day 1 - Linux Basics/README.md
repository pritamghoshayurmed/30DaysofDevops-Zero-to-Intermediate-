# Day 1: Linux Basics

Welcome to Day 1 of your DevOps 30-Day Roadmap! This README provides a comprehensive, beginner-friendly introduction to Linux basics. We'll cover fundamental concepts, explore the Linux file system through a detailed analysis of the root directory listing, and dive deep into 10 key areas: commands, file permissions, processes, and package managers.

## What is Linux?

Linux is an open-source, Unix-like operating system kernel that serves as the foundation for many operating systems. Unlike proprietary systems like Windows or macOS, Linux is free to use, modify, and distribute. It's widely used in servers, embedded systems, mobile devices (Android is based on Linux), and increasingly on desktops.

Linux was created by Linus Torvalds in 1991 as a hobby project while he was a student at the University of Helsinki. The name "Linux" comes from a combination of "Linus" and "Unix."

## What is the Linux Kernel?

The Linux kernel is the core component of the Linux operating system. It's the bridge between hardware and software, managing system resources such as CPU, memory, and input/output devices. The kernel handles:

- **Process management**: Creating, scheduling, and terminating processes
- **Memory management**: Allocating and deallocating memory for processes
- **Device drivers**: Communicating with hardware devices
- **File system management**: Organizing and accessing files on storage devices
- **Network management**: Handling network communications

The kernel is monolithic, meaning all core functions are integrated into a single program, which makes it efficient but requires careful development.

## What are Linux Distributions?

Linux distributions (often called "distros") are complete operating systems built around the Linux kernel. They include the kernel plus additional software packages, package managers, and user interfaces. Popular distributions include:

- **Ubuntu**: User-friendly, great for beginners and desktops
- **CentOS/RHEL**: Enterprise-focused, stable for servers
- **Debian**: Known for stability and vast software repositories
- **Fedora**: Cutting-edge features, sponsored by Red Hat
- **Arch Linux**: Minimalist, "do-it-yourself" approach
- **Kali Linux**: Specialized for penetration testing and security

Each distribution has its own package management system, default desktop environment, and target use case.

## How is Linux Different from Windows?

Linux differs from Windows in several fundamental ways:

1. **Open Source**: Linux is free and open-source; Windows is proprietary
2. **Kernel Architecture**: Linux uses a monolithic kernel; Windows uses a hybrid kernel
3. **File System**: Linux is case-sensitive; Windows is case-insensitive
4. **User Permissions**: Linux has a strict multi-user system with root/superuser; Windows has administrator privileges
5. **Package Management**: Linux uses package managers; Windows uses installers or Microsoft Store
6. **Customization**: Linux offers extensive customization; Windows is more standardized
7. **Command Line**: Linux relies heavily on the terminal; Windows has GUI-centric design
8. **Security**: Linux has fewer viruses due to smaller user base and permission model
9. **Cost**: Linux is free; Windows requires licensing
10. **Hardware Requirements**: Linux often runs on older, less powerful hardware

## Exploring the Linux File System: Root Directory Analysis

Let's examine the output of `ls -ltr` in the root directory of an Ubuntu system. This command lists files and directories in long format, sorted by modification time (newest last).

```bash
root@LAPTOP-IMV4I4GB:/# ls -ltr
total 2740
drwxr-xr-x   2 root root    4096 Feb 26  2024 bin.usr-is-merged
drwxr-xr-x   2 root root    4096 Mar 31  2024 sbin.usr-is-merged
drwxr-xr-x   2 root root    4096 Apr  8  2024 lib.usr-is-merged
lrwxrwxrwx   1 root root       8 Apr 22  2024 sbin -> usr/sbin
lrwxrwxrwx   1 root root       9 Apr 22  2024 lib64 -> usr/lib64
lrwxrwxrwx   1 root root       7 Apr 22  2024 lib -> usr/lib
drwxr-xr-x   2 root root    4096 Apr 22  2024 boot
lrwxrwxrwx   1 root root       7 Apr 22  2024 bin -> usr/bin
drwxr-xr-x   2 root root    4096 Jan  6  2025 srv
drwxr-xr-x   2 root root    4096 Jan  6  2025 opt
drwxr-xr-x   2 root root    4096 Jan  6  2025 media
drwxr-xr-x  12 root root    4096 Jan  6  2025 usr
-rwxrwxrwx   1 root root 2724480 Jun  9 18:32 init
drwx------   2 root root   16384 Aug  6 16:05 lost+found
drwxr-xr-x   6 root root    4096 Aug  6 16:06 mnt
drwxr-xr-x  13 root root    4096 Aug  6 16:06 var
drwxr-xr-x   2 root root    4096 Aug  6 16:06 snap
drwxr-xr-x   2 root root    4096 Aug  6 16:23 home
drwx------   5 root root    4096 Aug  6 16:25 root
dr-xr-xr-x  13 root root       0 Sep 17 12:24 sys
dr-xr-xr-x 266 root root       0 Sep 17 12:24 proc
drwxr-xr-x  15 root root    3860 Sep 17 12:24 dev
drwxrwxrwt   9 root root    4096 Sep 17 12:24 tmp
drwxr-xr-x  87 root root    4096 Sep 17 12:24 etc
drwxr-xr-x  19 root root     580 Sep 17 12:24 run
```

### Understanding the Output Format

Each line represents a file or directory with the following information:
- **Permissions**: 10 characters showing file type and permissions (e.g., `drwxr-xr-x`)
- **Links**: Number of hard links
- **Owner**: User who owns the file
- **Group**: Group that owns the file
- **Size**: File size in bytes
- **Date**: Last modification date
- **Name**: File or directory name

### Key Directories Explained

1. **bin.usr-is-merged, sbin.usr-is-merged, lib.usr-is-merged**: These are transitional directories created during Ubuntu's merge of `/bin`, `/sbin`, and `/lib` into `/usr`. They ensure compatibility.

2. **sbin, lib64, lib, bin** (symbolic links): These are symbolic links pointing to directories in `/usr`. This is part of the "usr merge" in modern Linux distributions.

3. **boot**: Contains the Linux kernel, initial RAM disk, and boot loader files.

4. **srv**: Holds data for services provided by the system (like web servers).

5. **opt**: Used for optional software packages not part of the base distribution.

6. **media**: Mount point for removable media like USB drives and CDs.

7. **usr**: Contains user programs, libraries, documentation, and other read-only data.

8. **init**: The system initialization program (likely systemd init).

9. **lost+found**: Directory where fsck (file system check) places recovered files after a system crash.

10. **mnt**: Temporary mount point for file systems.

11. **var**: Contains variable data like logs, databases, and spool files that change during system operation.

12. **snap**: Contains snap packages (Ubuntu's package format for sandboxed applications).

13. **home**: User home directories.

14. **root**: Home directory for the root user.

15. **sys**: Virtual file system providing information about the kernel, hardware, and system.

16. **proc**: Virtual file system containing information about running processes and system resources.

17. **dev**: Contains device files representing hardware devices.

18. **tmp**: Temporary files directory, cleared on reboot.

19. **etc**: System-wide configuration files.

20. **run**: Contains runtime data for processes started since the last boot.

## 10 Detailed Discussions: Commands, File Permissions, Processes, and Package Managers

### 1. Basic Navigation Commands

Linux navigation relies heavily on the command line. Key commands include:

- **pwd** (Print Working Directory): Shows your current location
  ```bash
  pwd
  # Output: /home/user
  ```

- **ls** (List): Lists directory contents
  ```bash
  ls -l  # Long listing format
  ls -a  # Show hidden files
  ls -h  # Human-readable sizes
  ```

- **cd** (Change Directory): Moves between directories
  ```bash
  cd /home/user/Documents  # Absolute path
  cd ../..                # Go up two levels
  cd ~                    # Go to home directory
  ```

### 2. File Manipulation Commands

Creating, copying, moving, and deleting files are essential operations:

- **touch**: Creates empty files or updates timestamps
  ```bash
  touch newfile.txt
  ```

- **mkdir**: Creates directories
  ```bash
  mkdir new_directory
  mkdir -p parent/child/grandchild  # Create nested directories
  ```

- **cp**: Copies files and directories
  ```bash
  cp source.txt destination.txt
  cp -r source_dir destination_dir  # Recursive copy
  ```

- **mv**: Moves or renames files
  ```bash
  mv oldname.txt newname.txt
  mv file.txt /new/location/
  ```

- **rm**: Removes files and directories
  ```bash
  rm file.txt
  rm -r directory  # Recursive removal
  rm -rf directory  # Force removal without prompts
  ```

### 3. File Permissions: Understanding and Managing Access

Linux file permissions control who can read, write, or execute files. Each file has permissions for owner, group, and others.

**Permission Types:**
- **r** (read): View file contents or list directory
- **w** (write): Modify file or directory contents
- **x** (execute): Run file as program or access directory

**Viewing Permissions:**
```bash
ls -l file.txt
# Output: -rw-r--r-- 1 user group 1024 Sep 17 12:00 file.txt
```

**Changing Permissions:**
```bash
chmod 755 file.txt  # rwxr-xr-x
chmod u+x file.txt  # Add execute for owner
chmod g-w file.txt  # Remove write for group
chmod o+r file.txt  # Add read for others
```

**Changing Ownership:**
```bash
chown user:group file.txt
sudo chown root:root file.txt  # Requires root privileges
```

### 4. Processes: Monitoring and Managing System Tasks

Processes are running programs. Linux provides tools to view and control them.

**Viewing Processes:**
```bash
ps aux  # Show all processes
top     # Interactive process viewer
htop    # Enhanced top (if installed)
```

**Process States:**
- **R**: Running
- **S**: Sleeping (interruptible)
- **D**: Sleeping (uninterruptible)
- **Z**: Zombie
- **T**: Stopped

**Managing Processes:**
```bash
kill 1234      # Send SIGTERM to process 1234
kill -9 1234   # Force kill with SIGKILL
pkill firefox  # Kill by name
```

### 5. Package Managers: Installing and Managing Software

Package managers handle software installation, updates, and removal.

**APT (Advanced Package Tool) - Debian/Ubuntu:**
```bash
sudo apt update          # Update package list
sudo apt upgrade         # Upgrade all packages
sudo apt install package # Install software
sudo apt remove package  # Remove software
sudo apt search keyword  # Search for packages
```

**YUM/DNF - Red Hat/CentOS/Fedora:**
```bash
sudo yum install package  # YUM
sudo dnf install package  # DNF (newer)
```

**Snap - Universal Linux packages:**
```bash
sudo snap install package
sudo snap remove package
```

### 6. Text Processing Commands

Linux excels at text manipulation with powerful command-line tools.

**cat**: Concatenate and display files
```bash
cat file.txt
cat file1.txt file2.txt > combined.txt
```

**grep**: Search for patterns in files
```bash
grep "search term" file.txt
grep -r "pattern" /directory  # Recursive search
grep -i "case insensitive" file.txt
```

**sed**: Stream editor for text transformation
```bash
sed 's/old/new/g' file.txt  # Replace text
```

**awk**: Pattern scanning and processing language
```bash
awk '{print $1}' file.txt  # Print first column
```

### 7. File System Navigation and Information

Understanding disk usage and file system structure is crucial.

**df**: Show disk space usage
```bash
df -h  # Human-readable format
```

**du**: Show directory space usage
```bash
du -sh /directory  # Summary for directory
du -h /directory   # All subdirectories
```

**find**: Search for files
```bash
find /home -name "*.txt"  # Find text files
find / -type f -size +100M  # Find large files
```

**locate**: Fast file search using database
```bash
locate filename
sudo updatedb  # Update locate database
```

### 8. User and Group Management

Linux is a multi-user system with sophisticated user management.

**User Commands:**
```bash
whoami     # Show current user
id         # Show user and group IDs
passwd     # Change password
```

**User Management (requires root):**
```bash
sudo useradd newuser
sudo userdel user
sudo usermod -aG group user  # Add user to group
```

**Group Management:**
```bash
groups user     # Show user's groups
sudo groupadd newgroup
sudo groupdel group
```

### 9. System Information and Monitoring

Gathering system information helps with troubleshooting and optimization.

**System Info:**
```bash
uname -a     # System information
hostname     # System hostname
uptime       # System uptime
free -h      # Memory usage
lscpu        # CPU information
lsblk        # Block devices
```

**Network Info:**
```bash
ip addr      # Network interfaces
ip route     # Routing table
ping host    # Test connectivity
```

### 10. Archiving and Compression

Managing file archives is essential for backups and transfers.

**tar**: Tape archiver
```bash
tar -cvf archive.tar files/    # Create archive
tar -xvf archive.tar           # Extract archive
tar -czvf archive.tar.gz files/  # Create compressed archive
tar -xzvf archive.tar.gz       # Extract compressed archive
```

**gzip/bzip2**: Compression tools
```bash
gzip file.txt     # Compress (creates file.txt.gz)
gunzip file.txt.gz  # Decompress
bzip2 file.txt    # Better compression
bunzip2 file.txt.bz2
```

**zip/unzip**: Cross-platform compression
```bash
zip archive.zip files/
unzip archive.zip
```

---

This comprehensive guide covers the fundamentals of Linux basics. Practice these commands in a safe environment, and remember to use `man command` for detailed help on any command. As you progress through the 30-day roadmap, these concepts will build upon each other. Happy learning!