# 📚 Git Commands Reference Guide

## 🎯 **Quick Navigation**

- [🚀 Setup & Configuration](#-setup--configuration)
- [🏗️ Repository Management](#️-repository-management)
- [📁 File Operations](#-file-operations)
- [💾 Staging & Committing](#-staging--committing)
- [📊 Status & Information](#-status--information)
- [🌿 Branching](#-branching)
- [🔀 Merging](#-merging)
- [🌐 Remote Repositories](#-remote-repositories)
- [⏮️ Undoing Changes](#️-undoing-changes)
- [🏷️ Tags](#️-tags)
- [🔍 Searching & Debugging](#-searching--debugging)
- [🛠️ Advanced Commands](#️-advanced-commands)

---

## 🚀 **Setup & Configuration**

### 👤 **Identity Setup**
```bash
# Set global username
git config --global user.name "Your Name"

# Set global email
git config --global user.email "your.email@example.com"

# Set local repository user (for specific project)
git config user.name "Project Specific Name"
git config user.email "project@email.com"
```

### ⚙️ **Configuration Options**
```bash
# Set default editor
git config --global core.editor "code"          # VS Code
git config --global core.editor "vim"           # Vim
git config --global core.editor "nano"          # Nano

# Set default branch name
git config --global init.defaultBranch main

# Enable colored output
git config --global color.ui auto

# Set line ending preferences
git config --global core.autocrlf true          # Windows
git config --global core.autocrlf input         # Mac/Linux

# Set up aliases
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.cm commit
```

### 🔍 **View Configuration**
```bash
# List all configurations
git config --list

# List global configurations
git config --global --list

# Show specific config
git config user.name

# Show config with file locations
git config --list --show-origin

# Edit global config file
git config --global --edit
```

---

## 🏗️ **Repository Management**

### 🆕 **Creating Repositories**
```bash
# Initialize new repository
git init

# Initialize with specific branch name
git init -b main

# Initialize bare repository (for servers)
git init --bare

# Clone repository
git clone <url>

# Clone to specific directory
git clone <url> <directory>

# Clone specific branch
git clone -b <branch> <url>

# Shallow clone (limited history)
git clone --depth 1 <url>
```

### 📂 **Repository Information**
```bash
# Show remote URLs
git remote -v

# Show repository info
git remote show origin

# List all remotes
git remote

# Check if directory is a git repository
git rev-parse --is-inside-work-tree
```

---

## 📁 **File Operations**

### ➕ **Adding Files**
```bash
# Add specific file
git add <filename>

# Add multiple files
git add file1.txt file2.txt

# Add all files in current directory
git add .

# Add all files (including deleted)
git add -A

# Add all modified files (not untracked)
git add -u

# Interactive staging
git add -i

# Patch staging (select parts of files)
git add -p
```

### 🗑️ **Removing Files**
```bash
# Remove file from Git and filesystem
git rm <filename>

# Remove file from Git only (keep locally)
git rm --cached <filename>

# Remove directory
git rm -r <directory>

# Remove files matching pattern
git rm '*.txt'

# Force removal
git rm -f <filename>
```

### 🔄 **Moving/Renaming Files**
```bash
# Rename/move file
git mv <old-name> <new-name>

# This is equivalent to:
mv <old-name> <new-name>
git rm <old-name>
git add <new-name>
```

---

## 💾 **Staging & Committing**

### 📝 **Committing Changes**
```bash
# Commit with message
git commit -m "Your commit message"

# Commit and stage all tracked files
git commit -am "Your commit message"

# Commit with detailed message using editor
git commit

# Amend last commit (change message or add changes)
git commit --amend

# Amend without changing commit message
git commit --amend --no-edit

# Empty commit (useful for triggering CI)
git commit --allow-empty -m "Trigger CI"

# Commit with specific date
git commit --date="2023-01-01 12:00:00" -m "Backdated commit"
```

### 🎯 **Staging Operations**
```bash
# Unstage file
git restore --staged <filename>

# Unstage all files
git restore --staged .

# Reset staging area to last commit
git reset HEAD

# Show what's staged
git diff --cached

# Show what's not staged
git diff
```

---

## 📊 **Status & Information**

### 📋 **Repository Status**
```bash
# Show repository status
git status

# Short status format
git status -s

# Show ignored files too
git status --ignored

# Show status in branch format
git status -b

# Porcelain format (for scripts)
git status --porcelain
```

### 📜 **Commit History**
```bash
# Show commit history
git log

# One line per commit
git log --oneline

# Show last N commits
git log -n 5

# Show commits with file changes
git log --stat

# Show commits with actual changes
git log -p

# Graphical representation
git log --graph --oneline --all

# Show commits by author
git log --author="John Doe"

# Show commits in date range
git log --since="2023-01-01" --until="2023-12-31"

# Show commits affecting specific file
git log -- <filename>

# Show commits with specific message pattern
git log --grep="fix"

# Beautiful graph format
git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'
```

### 🔍 **Differences**
```bash
# Show unstaged changes
git diff

# Show staged changes
git diff --cached
git diff --staged

# Compare two commits
git diff <commit1> <commit2>

# Compare working directory to specific commit
git diff HEAD~1

# Show changes in specific file
git diff <filename>

# Word-level differences
git diff --word-diff

# Side-by-side comparison
git diff --color-words

# Show only names of changed files
git diff --name-only

# Show summary of changes
git diff --stat
```

---

## 🌿 **Branching**

### 🌱 **Creating & Switching Branches**
```bash
# List all branches
git branch

# List all branches (including remote)
git branch -a

# List remote branches only
git branch -r

# Create new branch
git branch <branch-name>

# Create and switch to new branch
git checkout -b <branch-name>
git switch -c <branch-name>      # Modern syntax

# Switch to existing branch
git checkout <branch-name>
git switch <branch-name>         # Modern syntax

# Switch to previous branch
git checkout -
git switch -
```

### 🔄 **Branch Management**
```bash
# Rename current branch
git branch -m <new-name>

# Rename specific branch
git branch -m <old-name> <new-name>

# Delete branch (safe - checks if merged)
git branch -d <branch-name>

# Force delete branch
git branch -D <branch-name>

# Delete remote branch
git push origin --delete <branch-name>

# Show branch information
git branch -v

# Show merged branches
git branch --merged

# Show unmerged branches  
git branch --no-merged

# Set upstream branch
git branch --set-upstream-to=origin/<branch> <local-branch>
```

---

## 🔀 **Merging**

### 🤝 **Basic Merging**
```bash
# Merge branch into current branch
git merge <branch-name>

# Merge with no fast-forward (creates merge commit)
git merge --no-ff <branch-name>

# Merge with fast-forward only (fails if not possible)
git merge --ff-only <branch-name>

# Abort merge in case of conflicts
git merge --abort

# Continue merge after resolving conflicts
git merge --continue
```

### 🔧 **Advanced Merging**
```bash
# Squash merge (combine all commits into one)
git merge --squash <branch-name>

# Merge with custom commit message
git merge -m "Custom merge message" <branch-name>

# Show merge base
git merge-base <branch1> <branch2>

# Dry run merge (see what would happen)
git merge --no-commit --no-ff <branch-name>
```

### ⚡ **Rebase**
```bash
# Rebase current branch onto another
git rebase <base-branch>

# Interactive rebase (edit history)
git rebase -i <base-commit>

# Continue rebase after resolving conflicts
git rebase --continue

# Abort rebase
git rebase --abort

# Skip current commit during rebase
git rebase --skip

# Rebase onto specific commit
git rebase --onto <newbase> <upstream> <branch>
```

---

## 🌐 **Remote Repositories**

### 🔗 **Remote Management**
```bash
# Add remote
git remote add <name> <url>

# Remove remote
git remote remove <name>

# Rename remote
git remote rename <old> <new>

# Change remote URL
git remote set-url <name> <new-url>

# Show remote info
git remote show <name>

# List all remotes with URLs
git remote -v

# Prune deleted remote branches
git remote prune origin
```

### ⬇️ **Fetching & Pulling**
```bash
# Fetch all changes from remote
git fetch

# Fetch from specific remote
git fetch <remote>

# Fetch specific branch
git fetch <remote> <branch>

# Pull changes (fetch + merge)
git pull

# Pull with rebase instead of merge
git pull --rebase

# Pull from specific remote/branch
git pull <remote> <branch>

# Set up tracking for pull/push
git branch --set-upstream-to=origin/<branch>
```

### ⬆️ **Pushing**
```bash
# Push to default remote/branch
git push

# Push and set upstream
git push -u origin <branch>

# Push specific branch
git push origin <branch>

# Push all branches
git push --all

# Push tags
git push --tags

# Force push (dangerous!)
git push --force

# Safe force push (won't overwrite others' work)
git push --force-with-lease

# Delete remote branch
git push origin --delete <branch>

# Push empty commit to trigger CI
git commit --allow-empty -m "Trigger CI" && git push
```

---

## ⏮️ **Undoing Changes**

### 🔄 **Working Directory Changes**
```bash
# Discard changes in working directory
git restore <filename>

# Discard all changes
git restore .

# Restore file to specific commit state
git restore --source=<commit> <filename>

# Restore deleted file
git restore <filename>
```

### 📦 **Staging Changes**
```bash
# Unstage file
git restore --staged <filename>

# Unstage all files
git restore --staged .

# Reset staging area
git reset HEAD
git reset HEAD <filename>
```

### 🔙 **Commit Changes**
```bash
# Undo last commit (keep changes in working directory)
git reset --soft HEAD~1

# Undo last commit (keep changes staged)
git reset --mixed HEAD~1
git reset HEAD~1              # Default mode

# Undo last commit (discard all changes)
git reset --hard HEAD~1

# Undo multiple commits
git reset --hard HEAD~3

# Reset to specific commit
git reset --hard <commit-hash>

# Create new commit that undoes changes
git revert <commit-hash>

# Revert merge commit
git revert -m 1 <merge-commit-hash>

# Revert without committing
git revert --no-commit <commit-hash>
```

### 🩹 **Fix Last Commit**
```bash
# Change last commit message
git commit --amend -m "New message"

# Add changes to last commit
git add <filename>
git commit --amend --no-edit

# Change author of last commit
git commit --amend --author="New Author <email@example.com>"
```

---

## 🏷️ **Tags**

### 🏷️ **Creating Tags**
```bash
# Create lightweight tag
git tag <tag-name>

# Create annotated tag
git tag -a <tag-name> -m "Tag message"

# Tag specific commit
git tag -a <tag-name> <commit-hash> -m "Message"

# Create signed tag
git tag -s <tag-name> -m "Message"
```

### 📋 **Managing Tags**
```bash
# List all tags
git tag

# List tags with pattern
git tag -l "v1.*"

# Show tag information
git show <tag-name>

# Delete tag
git tag -d <tag-name>

# Delete remote tag
git push origin --delete <tag-name>

# Push tags to remote
git push --tags

# Push specific tag
git push origin <tag-name>

# Checkout tag
git checkout <tag-name>
```

---

## 🔍 **Searching & Debugging**

### 🔎 **Search Content**
```bash
# Search in files
git grep "search-term"

# Search in specific file types
git grep "search-term" -- "*.js"

# Search with line numbers
git grep -n "search-term"

# Search with context lines
git grep -C 3 "search-term"

# Search in specific commit
git grep "search-term" <commit-hash>

# Case insensitive search
git grep -i "search-term"
```

### 🕵️ **Blame & History**
```bash
# Show who changed what line
git blame <filename>

# Blame with line numbers
git blame -L 10,20 <filename>

# Show file history
git log --follow -- <filename>

# Show when file was deleted
git log --full-history -- <filename>

# Find when bug was introduced
git bisect start
git bisect bad
git bisect good <commit>
```

### 📊 **Statistics**
```bash
# Show commit count by author
git shortlog -sn

# Show file change statistics
git diff --stat

# Show repository statistics
git log --stat --summary

# Show lines added/removed by author
git log --author="John" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }'
```

---

## 🛠️ **Advanced Commands**

### 📂 **Stashing**
```bash
# Stash current changes
git stash

# Stash with message
git stash save "Work in progress"

# List all stashes
git stash list

# Apply most recent stash
git stash apply

# Apply and remove stash
git stash pop

# Apply specific stash
git stash apply stash@{2}

# Drop specific stash
git stash drop stash@{2}

# Clear all stashes
git stash clear

# Create branch from stash
git stash branch <branch-name>

# Stash only staged changes
git stash --staged

# Stash including untracked files
git stash -u

# Interactive stashing
git stash -p
```

### 🌳 **Subtrees & Submodules**
```bash
# Add subtree
git subtree add --prefix=<folder> <remote-url> <branch> --squash

# Pull subtree changes
git subtree pull --prefix=<folder> <remote-url> <branch> --squash

# Push subtree changes
git subtree push --prefix=<folder> <remote-url> <branch>

# Add submodule
git submodule add <remote-url> <path>

# Update submodules
git submodule update --init --recursive

# Pull submodule changes
git submodule update --remote
```

### 🧹 **Maintenance**
```bash
# Clean untracked files (dry run)
git clean -n

# Clean untracked files
git clean -f

# Clean untracked files and directories
git clean -fd

# Interactive clean
git clean -i

# Garbage collection
git gc

# Aggressive garbage collection
git gc --aggressive

# Prune unreachable objects
git prune

# Check repository integrity
git fsck

# Show repository size
git count-objects -vH

# Compress repository
git repack -ad
```

### 🔧 **Configuration & Hooks**
```bash
# List all configs
git config --list

# Edit config file
git config --edit

# Set up hooks directory
git config core.hooksPath <hooks-directory>

# Create pre-commit hook
echo '#!/bin/bash\necho "Running pre-commit hook"' > .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

# Skip hooks for commit
git commit --no-verify -m "Skip hooks"
```

---

## 📝 **Useful Aliases**

Add these to your `.gitconfig`:

```bash
[alias]
    # Short commands
    st = status
    co = checkout
    br = branch
    cm = commit
    cp = cherry-pick
    
    # Log aliases
    lg = log --graph --oneline --all
    ll = log --oneline
    lp = log --patch
    ls = log --stat
    
    # Diff aliases
    dt = difftool
    mt = mergetool
    
    # Branch aliases  
    bv = branch -v
    bd = branch -d
    ba = branch -a
    
    # Remote aliases
    rv = remote -v
    ra = remote add
    rr = remote remove
    
    # Stash aliases
    sl = stash list
    ss = stash save
    sp = stash pop
    
    # Undo aliases
    unstage = reset HEAD
    last = log -1 HEAD
    undo = reset --soft HEAD~1
    
    # Advanced aliases
    find = "!git ls-files | grep -i"
    grep = grep -Ii
    contributors = shortlog -sn
    
    # Workflow aliases
    ready = rebase -i @{u}
    publish = "!git push -u origin $(git branch --show-current)"
    unpublish = "!git push origin :$(git branch --show-current)"
```

---

## 💡 **Pro Tips & Shortcuts**

### ⚡ **Quick Commands**
```bash
# Quick status check
git status -s

# Last commit info
git log -1

# Changes since last pull
git log HEAD..origin/main --oneline

# Files changed in last commit
git diff-tree --no-commit-id --name-only -r HEAD

# Current branch name
git branch --show-current

# Number of commits ahead/behind
git rev-list --count --left-right HEAD...origin/main
```

### 🎯 **One-Liners**
```bash
# Create and push new branch
git checkout -b new-feature && git push -u origin new-feature

# Add, commit, and push
git add . && git commit -m "Quick update" && git push

# Update all branches
git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done

# Delete merged branches
git branch --merged | grep -v "\*" | xargs -n 1 git branch -d

# Show files in last commit
git show --pretty="format:" --name-only HEAD

# Count total commits
git rev-list --all --count
```

---

## ❓ **Troubleshooting Common Issues**

### 🚨 **Merge Conflicts**
```bash
# Check conflict status
git status

# Open merge tool
git mergetool

# After resolving conflicts
git add <resolved-files>
git commit

# Or abort merge
git merge --abort
```

### 🔄 **Detached HEAD**
```bash
# Check if in detached HEAD
git branch

# Create branch from detached HEAD
git checkout -b new-branch

# Return to main branch
git checkout main
```

### 📁 **Large Files**
```bash
# Find large files in repository
git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | sed -n 's/^blob //p' | sort --numeric-sort --key=2 --reverse | head -20

# Remove file from history
git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch PATH-TO-YOUR-FILE-WITH-SENSITIVE-DATA' --prune-empty --tag-name-filter cat -- --all
```

---

*📘 This reference guide covers the most commonly used Git commands. For more detailed information, use `git help <command>` or visit the [official Git documentation](https://git-scm.com/doc).*