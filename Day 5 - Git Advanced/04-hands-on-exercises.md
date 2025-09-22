# 💪 Hands-on Exercises: Advanced Git Mastery

<div style="background: linear-gradient(45deg, #667eea 0%, #764ba2 100%); padding: 20px; border-radius: 15px; color: white; text-align: center; margin-bottom: 30px;">
  <h2>🎯 Practice Makes Perfect</h2>
  <p>Master advanced Git techniques through real-world scenarios and challenges</p>
</div>

## 📚 **Table of Contents**

1. [🏗️ Setup Your Practice Environment](#️-setup-your-practice-environment)
2. [🥉 Bronze Level: Basic Advanced Operations](#-bronze-level-basic-advanced-operations)
3. [🥈 Silver Level: Complex Scenarios](#-silver-level-complex-scenarios)
4. [🥇 Gold Level: Professional Workflows](#-gold-level-professional-workflows)
5. [💎 Platinum Level: Expert Challenges](#-platinum-level-expert-challenges)
6. [🔍 Interactive Learning Labs](#-interactive-learning-labs)
7. [🎯 Real-World Projects](#-real-world-projects)
8. [✅ Solutions and Explanations](#-solutions-and-explanations)

---

## 🏗️ **Setup Your Practice Environment**

### 🎯 **Create Practice Repository**

```bash
# Create main practice directory
mkdir git-advanced-practice
cd git-advanced-practice

# Initialize repository
git init

# Configure for practice
git config user.name "Git Student"
git config user.email "student@gitpractice.com"

# Create initial structure
echo "# Git Advanced Practice Repository" > README.md
echo "node_modules/" > .gitignore
echo "*.log" >> .gitignore

# Initial commit
git add .
git commit -m "Initial commit: setup practice repository"

# Create and switch to develop branch
git checkout -b develop
echo "Development branch created" >> README.md
git add .
git commit -m "feat: create develop branch"
```

### 🛠️ **Generate Sample Content**

```bash
# Create sample project structure
mkdir -p src/{components,utils,services}
mkdir -p docs
mkdir -p tests

# Create sample files
cat > src/app.js << 'EOF'
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.json({ message: 'Hello, World!' });
});

module.exports = app;
EOF

cat > src/utils/helper.js << 'EOF'
function formatDate(date) {
  return date.toISOString().split('T')[0];
}

function generateId() {
  return Math.random().toString(36).substr(2, 9);
}

module.exports = { formatDate, generateId };
EOF

cat > package.json << 'EOF'
{
  "name": "git-practice-app",
  "version": "1.0.0",
  "description": "Practice application for Git advanced concepts",
  "main": "src/app.js",
  "scripts": {
    "test": "jest",
    "start": "node src/app.js"
  },
  "dependencies": {
    "express": "^4.18.0"
  },
  "devDependencies": {
    "jest": "^29.0.0"
  }
}
EOF

# Commit the structure
git add .
git commit -m "feat: add basic project structure and package.json"
```

### 🌐 **Setup Remote (Optional)**

```bash
# If you want to practice with remote repositories
# Create a repository on GitHub/GitLab first, then:

git remote add origin <your-remote-url>
git push -u origin develop
git push origin main
```

---

## 🥉 **Bronze Level: Basic Advanced Operations**

### 📝 **Exercise 1: Interactive Rebase Mastery**

**Objective**: Clean up messy commit history using interactive rebase

**Setup:**
```bash
# Create a feature branch with messy commits
git checkout -b feature/user-auth

# Make several commits (intentionally messy)
echo "// TODO: Add authentication" >> src/app.js
git add .
git commit -m "WIP: starting auth"

echo "const bcrypt = require('bcrypt');" >> src/app.js
git add .
git commit -m "add bcrypt"

echo "// More auth logic here" >> src/app.js
git add .
git commit -m "more stuff"

echo "console.log('Debug: auth working');" >> src/app.js
git add .
git commit -m "debug statement"

echo "// Final auth implementation" >> src/app.js
git add .
git commit -m "Fix typo in authentication"

echo "module.exports = app;" >> src/app.js
git add .
git commit -m "final auth commit"
```

**Your Mission:**
1. Use interactive rebase to clean up the last 6 commits
2. Combine related commits using `squash`
3. Remove the debug commit using `drop`
4. Reword commit messages to follow conventional format
5. Result should be 2-3 clean, descriptive commits

**Commands to use:**
```bash
git log --oneline -10
git rebase -i HEAD~6
# Edit the rebase plan, then save
git log --oneline -10  # Verify results
```

**Success Criteria:**
- Clean commit history with meaningful messages
- No debug or "WIP" commits
- Follows conventional commit format (`feat:`, `fix:`, etc.)

---

### 📝 **Exercise 2: Cherry-picking Across Branches**

**Objective**: Selectively apply commits between branches

**Setup:**
```bash
# Create two feature branches
git checkout develop
git checkout -b feature/api-endpoints

# Add some API endpoints
cat >> src/app.js << 'EOF'

app.get('/users', (req, res) => {
  res.json({ users: [] });
});

app.post('/users', (req, res) => {
  res.json({ message: 'User created' });
});
EOF

git add .
git commit -m "feat: add user API endpoints"

# Add another feature
echo "app.get('/health', (req, res) => res.json({ status: 'OK' }));" >> src/app.js
git add .
git commit -m "feat: add health check endpoint"

# Add a bug (intentionally)
echo "app.get('/admin', (req, res) => res.json({ admin: true }));" >> src/app.js
git add .
git commit -m "feat: add admin endpoint (security issue)"

# Create another branch
git checkout develop
git checkout -b feature/database

# Add database code
cat > src/services/database.js << 'EOF'
const db = {
  connect: () => console.log('Connected to database'),
  disconnect: () => console.log('Disconnected from database')
};

module.exports = db;
EOF

git add .
git commit -m "feat: add database service"

# Add database integration
echo "const db = require('./services/database');" >> src/app.js
git add .
git commit -m "feat: integrate database service"
```

**Your Mission:**
1. Cherry-pick only the user API endpoints commit to the database branch
2. Cherry-pick the health check endpoint to the database branch
3. Do NOT cherry-pick the admin endpoint (security issue)
4. Resolve any conflicts that occur

**Commands to use:**
```bash
git log --oneline feature/api-endpoints
git cherry-pick <commit-hash>
git status  # Check for conflicts
git log --oneline  # Verify results
```

**Success Criteria:**
- Database branch has user and health endpoints
- No security-vulnerable admin endpoint
- All commits apply cleanly

---

### 📝 **Exercise 3: Advanced Stashing**

**Objective**: Master complex stashing scenarios

**Setup:**
```bash
# Start working on multiple changes
git checkout develop

# Modify existing files
echo "// Performance improvements needed" >> src/app.js

# Create new untracked file
cat > src/components/UserProfile.js << 'EOF'
function UserProfile({ user }) {
  return `<div>Hello, ${user.name}!</div>`;
}

module.exports = UserProfile;
EOF

# Modify another file
echo "// Updated utility functions" >> src/utils/helper.js
```

**Your Mission:**
1. Stash only the tracked file changes (not the new file)
2. Create a new branch and apply the stash there
3. Go back to develop and stash everything including untracked files
4. Create another branch from the complete stash
5. Apply stashes selectively to different branches

**Commands to use:**
```bash
git status
git stash save "Performance improvements WIP"
git stash -u -m "Complete UI work including new components"
git stash list
git stash show stash@{0}
git stash branch <branch-name> stash@{1}
```

**Success Criteria:**
- Multiple stashes with descriptive names
- Selective application of stashes
- Clean working directory when needed

---

## 🥈 **Silver Level: Complex Scenarios**

### 📝 **Exercise 4: Complex Merge Conflict Resolution**

**Objective**: Handle complex merge scenarios like a pro

**Setup:**
```bash
# Create conflicting changes in multiple branches
git checkout develop

# Branch 1: API refactoring
git checkout -b refactor/api-structure

cat > src/app.js << 'EOF'
const express = require('express');
const userRoutes = require('./routes/users');
const adminRoutes = require('./routes/admin');

const app = express();

app.use('/api/v1/users', userRoutes);
app.use('/api/v1/admin', adminRoutes);

app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy',
    timestamp: Date.now(),
    version: '1.0.0'
  });
});

module.exports = app;
EOF

# Create route files
mkdir -p src/routes
cat > src/routes/users.js << 'EOF'
const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
  res.json({ users: [] });
});

router.post('/', (req, res) => {
  res.json({ message: 'User created successfully' });
});

module.exports = router;
EOF

git add .
git commit -m "refactor: restructure API with separate route files"

# Branch 2: Different API approach
git checkout develop
git checkout -b feature/enhanced-api

cat > src/app.js << 'EOF'
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');

const app = express();

// Middleware
app.use(cors());
app.use(helmet());
app.use(express.json());

// Enhanced endpoints
app.get('/api/users', async (req, res) => {
  try {
    // Enhanced logic with error handling
    const users = await getUsersFromDB();
    res.json({ 
      success: true,
      data: users,
      count: users.length 
    });
  } catch (error) {
    res.status(500).json({ 
      success: false,
      error: error.message 
    });
  }
});

app.post('/api/users', async (req, res) => {
  try {
    const newUser = await createUser(req.body);
    res.status(201).json({ 
      success: true,
      data: newUser 
    });
  } catch (error) {
    res.status(400).json({ 
      success: false,
      error: error.message 
    });
  }
});

app.get('/status', (req, res) => {
  res.json({ 
    status: 'operational',
    uptime: process.uptime(),
    memory: process.memoryUsage()
  });
});

module.exports = app;
EOF

git add .
git commit -m "feat: enhance API with middleware and error handling"
```

**Your Mission:**
1. Merge the refactor branch into develop
2. Then merge the enhanced API branch (this will conflict!)
3. Resolve conflicts by combining the best of both approaches:
   - Keep the route separation from refactor
   - Keep the middleware and error handling from enhanced
   - Merge the different health/status endpoint approaches
4. Test that the final result makes sense

**Commands to use:**
```bash
git checkout develop
git merge refactor/api-structure
git merge feature/enhanced-api
# Conflicts will occur - resolve them wisely
git status
git add .
git commit -m "merge: combine API refactoring with enhancements"
```

**Success Criteria:**
- Clean merge with no conflict markers
- Combined best practices from both branches
- Logical and functional final code structure

---

### 📝 **Exercise 5: Git Hooks Implementation**

**Objective**: Create automated quality control with Git hooks

**Your Mission:**
Create pre-commit and commit-msg hooks that enforce code quality

**Pre-commit Hook Requirements:**
1. Check for console.log statements
2. Run a simple linter check
3. Ensure no large files are committed
4. Validate that tests pass

**Commit-msg Hook Requirements:**
1. Enforce conventional commit format
2. Ensure commit messages are descriptive (min 10 chars)
3. Block commits with "WIP" or "TODO" in message

**Implementation:**
```bash
# Create pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

echo "🔍 Running pre-commit checks..."

# Check for console.log statements
if grep -r "console.log\|debugger" src/ --include="*.js"; then
    echo "❌ Found console.log or debugger statements. Please remove them."
    exit 1
fi

# Check for large files (>1MB)
for file in $(git diff --cached --name-only); do
    if [ -f "$file" ] && [ $(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo 0) -gt 1048576 ]; then
        echo "❌ File $file is too large (>1MB). Use Git LFS for large files."
        exit 1
    fi
done

# Simple linter check (check for basic syntax)
for file in $(git diff --cached --name-only --diff-filter=ACM | grep '\.js$'); do
    if [ -f "$file" ]; then
        # Basic syntax check with node
        if ! node -c "$file" 2>/dev/null; then
            echo "❌ Syntax error in $file"
            exit 1
        fi
    fi
done

echo "✅ Pre-commit checks passed!"
EOF

# Create commit-msg hook
cat > .git/hooks/commit-msg << 'EOF'
#!/bin/bash

commit_msg_file=$1
commit_msg=$(cat $commit_msg_file)

# Check conventional commit format
if ! echo "$commit_msg" | grep -qE '^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .{1,}'; then
    echo "❌ Commit message must follow conventional format:"
    echo "   feat: add new feature"
    echo "   fix: bug fix"
    echo "   docs: documentation changes"
    echo "   style: formatting, missing semicolons, etc"
    echo "   refactor: code change that neither fixes a bug nor adds a feature"
    echo "   test: adding missing tests"
    echo "   chore: maintain build scripts, etc"
    exit 1
fi

# Check message length
if [ ${#commit_msg} -lt 10 ]; then
    echo "❌ Commit message too short. Please be more descriptive."
    exit 1
fi

# Block WIP/TODO commits
if echo "$commit_msg" | grep -qi '\(wip\|todo\)'; then
    echo "❌ Commit message contains WIP or TODO. Please complete the work first."
    exit 1
fi

echo "✅ Commit message format is valid!"
EOF

# Make hooks executable
chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/commit-msg
```

**Test Your Hooks:**
```bash
# Test pre-commit hook with bad code
echo "console.log('debug');" >> src/app.js
git add .
git commit -m "test: add debug statement"
# Should fail

# Fix and test with good commit
git reset HEAD~1
echo "// Clean code" >> src/app.js
git add .
git commit -m "feat: add clean implementation"
# Should pass

# Test commit-msg hook
git commit --allow-empty -m "bad message"
# Should fail

git commit --allow-empty -m "feat: proper conventional commit"
# Should pass
```

**Success Criteria:**
- Hooks prevent bad commits
- Quality standards are enforced
- Team workflow is improved

---

## 🥇 **Gold Level: Professional Workflows**

### 📝 **Exercise 6: GitFlow Implementation**

**Objective**: Implement complete GitFlow workflow for a release

**Setup:**
```bash
# Install git-flow or use manual commands
# We'll do it manually for learning

# Start from clean main
git checkout main
git pull origin main 2>/dev/null || true

# Create develop branch
git checkout -b develop
git push origin develop 2>/dev/null || true
```

**Your Mission:**
Simulate a complete release cycle:

1. **Feature Development Phase**
   - Create 3 feature branches
   - Implement different features
   - Merge features to develop

2. **Release Preparation**
   - Create release branch
   - Fix bugs found in testing
   - Update version numbers

3. **Production Release**
   - Merge to main
   - Create release tag
   - Merge back to develop

4. **Hotfix Scenario**
   - Critical bug found in production
   - Create hotfix branch
   - Fix and merge to both main and develop

**Implementation:**

**Phase 1: Feature Development**
```bash
# Feature 1: User registration
git checkout develop
git checkout -b feature/user-registration

cat > src/services/auth.js << 'EOF'
class AuthService {
  async register(userData) {
    // Validate user data
    if (!userData.email || !userData.password) {
      throw new Error('Email and password required');
    }
    
    // Hash password
    const hashedPassword = await this.hashPassword(userData.password);
    
    // Save user
    const user = await this.saveUser({
      ...userData,
      password: hashedPassword
    });
    
    return user;
  }
  
  async hashPassword(password) {
    // Mock implementation
    return `hashed_${password}`;
  }
  
  async saveUser(userData) {
    // Mock implementation
    return { id: Date.now(), ...userData };
  }
}

module.exports = new AuthService();
EOF

git add .
git commit -m "feat: implement user registration service"

# Finish feature
git checkout develop
git merge feature/user-registration --no-ff
git branch -d feature/user-registration

# Feature 2: User login
git checkout -b feature/user-login

cat >> src/services/auth.js << 'EOF'

async login(email, password) {
  // Find user by email
  const user = await this.findUserByEmail(email);
  if (!user) {
    throw new Error('User not found');
  }
  
  // Verify password
  const isValid = await this.verifyPassword(password, user.password);
  if (!isValid) {
    throw new Error('Invalid password');
  }
  
  // Generate token
  const token = this.generateToken(user);
  return { user, token };
}

async findUserByEmail(email) {
  // Mock implementation
  return email === 'test@example.com' ? { id: 1, email } : null;
}

async verifyPassword(password, hashedPassword) {
  return hashedPassword === `hashed_${password}`;
}

generateToken(user) {
  return `token_${user.id}_${Date.now()}`;
}
EOF

git add .
git commit -m "feat: implement user login functionality"

git checkout develop
git merge feature/user-login --no-ff
git branch -d feature/user-login

# Feature 3: Password reset
git checkout -b feature/password-reset

cat >> src/services/auth.js << 'EOF'

async requestPasswordReset(email) {
  const user = await this.findUserByEmail(email);
  if (!user) {
    throw new Error('User not found');
  }
  
  const resetToken = this.generateResetToken();
  await this.saveResetToken(user.id, resetToken);
  
  return resetToken;
}

async resetPassword(token, newPassword) {
  const userId = await this.validateResetToken(token);
  if (!userId) {
    throw new Error('Invalid or expired reset token');
  }
  
  const hashedPassword = await this.hashPassword(newPassword);
  await this.updateUserPassword(userId, hashedPassword);
  
  return { success: true };
}

generateResetToken() {
  return `reset_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
}

async saveResetToken(userId, token) {
  // Mock implementation
  console.log(`Saved reset token ${token} for user ${userId}`);
}

async validateResetToken(token) {
  // Mock implementation - return user ID if valid
  return token.startsWith('reset_') ? 1 : null;
}

async updateUserPassword(userId, hashedPassword) {
  // Mock implementation
  console.log(`Updated password for user ${userId}`);
}
EOF

git add .
git commit -m "feat: implement password reset functionality"

git checkout develop
git merge feature/password-reset --no-ff
git branch -d feature/password-reset
```

**Phase 2: Release Preparation**
```bash
# Create release branch
git checkout develop
git checkout -b release/1.1.0

# Update version in package.json
cat > package.json << 'EOF'
{
  "name": "git-practice-app",
  "version": "1.1.0",
  "description": "Practice application for Git advanced concepts",
  "main": "src/app.js",
  "scripts": {
    "test": "jest",
    "start": "node src/app.js"
  },
  "dependencies": {
    "express": "^4.18.0"
  },
  "devDependencies": {
    "jest": "^29.0.0"
  }
}
EOF

git add .
git commit -m "chore: bump version to 1.1.0"

# Fix a bug found during testing
sed -i 's/throw new Error/throw new AuthError/g' src/services/auth.js
cat >> src/services/auth.js << 'EOF'

class AuthError extends Error {
  constructor(message) {
    super(message);
    this.name = 'AuthError';
  }
}

module.exports.AuthError = AuthError;
EOF

git add .
git commit -m "fix: use specific AuthError instead of generic Error"

# Add changelog
cat > CHANGELOG.md << 'EOF'
# Changelog

## [1.1.0] - 2023-12-01

### Added
- User registration functionality
- User login with token generation
- Password reset feature

### Fixed
- Improved error handling with specific AuthError class

### Changed
- Enhanced authentication service structure
EOF

git add .
git commit -m "docs: add changelog for version 1.1.0"
```

**Phase 3: Production Release**
```bash
# Merge to main
git checkout main
git merge release/1.1.0 --no-ff -m "Release version 1.1.0"

# Create tag
git tag -a v1.1.0 -m "Release version 1.1.0

Features:
- User registration
- User login with tokens
- Password reset functionality

Improvements:
- Better error handling
- Comprehensive authentication service"

# Merge back to develop
git checkout develop
git merge release/1.1.0 --no-ff
git branch -d release/1.1.0

# Push everything
git push origin main develop --tags 2>/dev/null || true
```

**Phase 4: Hotfix**
```bash
# Critical bug discovered in production
git checkout main
git checkout -b hotfix/security-token-validation

# Fix the security issue
cat >> src/services/auth.js << 'EOF'

validateToken(token) {
  // Enhanced security validation
  if (!token || typeof token !== 'string') {
    return null;
  }
  
  // Check token format and expiration
  const parts = token.split('_');
  if (parts.length !== 3 || parts[0] !== 'token') {
    return null;
  }
  
  const userId = parseInt(parts[1]);
  const timestamp = parseInt(parts[2]);
  
  // Token expires after 1 hour
  if (Date.now() - timestamp > 3600000) {
    return null;
  }
  
  return userId;
}
EOF

git add .
git commit -m "fix: add proper token validation and expiration"

# Update version (patch)
sed -i 's/"version": "1.1.0"/"version": "1.1.1"/g' package.json
git add .
git commit -m "chore: bump version to 1.1.1"

# Merge to main
git checkout main
git merge hotfix/security-token-validation --no-ff

# Tag the hotfix
git tag -a v1.1.1 -m "Hotfix version 1.1.1 - Security improvement in token validation"

# Merge to develop
git checkout develop
git merge hotfix/security-token-validation --no-ff

# Clean up
git branch -d hotfix/security-token-validation
git push origin main develop --tags 2>/dev/null || true
```

**Success Criteria:**
- Clean GitFlow workflow implemented
- Proper merge commits with `--no-ff`
- Semantic versioning followed
- Tags created for releases
- Hotfix properly applied to both branches

---

### 📝 **Exercise 7: Large Repository Management**

**Objective**: Handle large repositories with performance optimization

**Setup:**
```bash
# Create a scenario with large files and long history
git checkout develop

# Simulate large binary files
dd if=/dev/zero of=large-dataset.csv bs=1024 count=2048  # 2MB file
dd if=/dev/zero of=backup.zip bs=1024 count=5120        # 5MB file
git add large-dataset.csv backup.zip
git commit -m "feat: add large data files"

# Create many commits to simulate long history
for i in {1..50}; do
    echo "Commit $i: $(date)" >> history.log
    git add history.log
    git commit -m "log: add entry $i"
done
```

**Your Mission:**
1. **Identify Performance Issues**
   - Analyze repository size and performance
   - Find large files in history
   - Identify optimization opportunities

2. **Implement Solutions**
   - Set up Git LFS for large files
   - Clean up unnecessary history
   - Optimize repository structure

3. **Performance Monitoring**
   - Measure improvements
   - Set up maintenance routines

**Implementation:**

**Step 1: Analysis**
```bash
# Check repository size
du -sh .git/
git count-objects -vH

# Find large files
git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | awk '/^blob/ {print substr($0,6)}' | sort --numeric-sort --key=2 | tail -10

# Performance test
time git log --oneline >/dev/null
time git status >/dev/null
```

**Step 2: Optimization**
```bash
# Install and configure Git LFS
git lfs install

# Track large file types
git lfs track "*.csv"
git lfs track "*.zip"
git lfs track "*.bin"

# Add .gitattributes
git add .gitattributes
git commit -m "chore: configure Git LFS for large files"

# Remove large files from history (DANGEROUS - backup first!)
git filter-branch --tree-filter 'rm -f large-dataset.csv backup.zip' HEAD
git push origin --force --all

# Clean up
git for-each-ref --format="delete %(refname)" refs/original | git update-ref --stdin
git reflog expire --expire=now --all
git gc --aggressive --prune=now

# Re-add files with LFS
git lfs track "*.csv" "*.zip"
# Add files back (they'll now use LFS)
echo "CSV data here" > large-dataset.csv  # Recreate with smaller content
git add large-dataset.csv
git commit -m "feat: re-add large files with LFS"
```

**Step 3: Performance Configuration**
```bash
# Configure for better performance
git config core.preloadindex true
git config core.fscache true
git config gc.auto 256

# Set up maintenance script
cat > .git/hooks/post-commit << 'EOF'
#!/bin/bash

# Run maintenance every 20 commits
commit_count=$(git rev-list --count HEAD)
if [ $((commit_count % 20)) -eq 0 ]; then
    echo "Running repository maintenance..."
    git gc --auto
fi
EOF

chmod +x .git/hooks/post-commit
```

**Success Criteria:**
- Reduced repository size
- Improved Git operation performance
- Large files properly managed with LFS
- Automated maintenance in place

---

## 💎 **Platinum Level: Expert Challenges**

### 📝 **Exercise 8: Custom Git Workflow**

**Objective**: Design and implement a custom Git workflow for a specific scenario

**Scenario**: You're working on a project that has:
- Multiple environments (dev, staging, prod)
- Feature flags for gradual rollouts
- Compliance requirements (audit trail)
- Multiple teams working on different components

**Your Mission:**
Design and implement a custom workflow that addresses all these requirements.

**Requirements:**
1. **Environment Management**
   - Separate branches for each environment
   - Controlled promotion between environments
   - Environment-specific configuration

2. **Feature Flag Integration**
   - Branch naming that indicates feature flag usage
   - Easy rollback capabilities
   - A/B testing support

3. **Compliance & Audit**
   - Signed commits
   - Detailed commit messages with ticket references
   - Protected branches with required reviews

4. **Team Collaboration**
   - Code ownership enforcement
   - Automated conflict prevention
   - Integration with CI/CD

**Implementation Example:**
```bash
# Create environment branches
git checkout main
git checkout -b production
git checkout main
git checkout -b staging  
git checkout main
git checkout -b development

# Set up branch protection (simulate with naming convention)
# In real scenario, you'd use GitHub/GitLab branch protection

# Create feature with flag
git checkout development
git checkout -b feature/PROJ-123-new-dashboard-ff

# Implement with feature flag
cat > src/features/dashboard.js << 'EOF'
const featureFlags = require('../config/featureFlags');

function renderDashboard(user) {
  if (featureFlags.isEnabled('NEW_DASHBOARD', user)) {
    return renderNewDashboard(user);
  }
  return renderOldDashboard(user);
}

function renderNewDashboard(user) {
  return {
    type: 'new',
    content: `Welcome to the new dashboard, ${user.name}!`,
    features: ['analytics', 'realtime', 'customization']
  };
}

function renderOldDashboard(user) {
  return {
    type: 'legacy', 
    content: `Hello, ${user.name}`,
    features: ['basic']
  };
}

module.exports = { renderDashboard };
EOF

# Feature flag configuration
cat > src/config/featureFlags.js << 'EOF'
class FeatureFlags {
  constructor() {
    this.flags = {
      'NEW_DASHBOARD': {
        enabled: false,
        rollout: 0.1, // 10% rollout
        environments: ['development', 'staging']
      }
    };
  }
  
  isEnabled(flagName, user) {
    const flag = this.flags[flagName];
    if (!flag) return false;
    
    const env = process.env.NODE_ENV || 'development';
    if (!flag.environments.includes(env)) return false;
    
    if (flag.enabled) return true;
    
    // Gradual rollout based on user ID
    if (user && user.id) {
      const userHash = this.hashUserId(user.id);
      return userHash < flag.rollout;
    }
    
    return false;
  }
  
  hashUserId(userId) {
    // Simple hash function for demo
    let hash = 0;
    const str = userId.toString();
    for (let i = 0; i < str.length; i++) {
      const char = str.charCodeAt(i);
      hash = ((hash << 5) - hash) + char;
      hash = hash & hash; // Convert to 32-bit integer
    }
    return Math.abs(hash) / 2147483647; // Normalize to 0-1
  }
}

module.exports = new FeatureFlags();
EOF

# Commit with proper format
git add .
git commit -S -m "feat(dashboard): implement new dashboard with feature flag

PROJ-123: Add new dashboard implementation with gradual rollout

- Implements new dashboard UI components
- Adds feature flag system for controlled rollout  
- Maintains backward compatibility with legacy dashboard
- Supports user-based gradual activation

Testing: Unit tests pass, manual testing completed
Reviewers: @team-lead, @senior-dev
Deploy: Requires feature flag configuration update"

# Create signed tag for release
git tag -s v1.2.0-beta.1 -m "Beta release with new dashboard feature flag"
```

**Advanced Workflow Automation:**
```bash
# Create workflow automation script
cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash

current_branch=$(git symbolic-ref --short HEAD)
remote_branch=$1
remote_url=$2

# Environment promotion rules
case "$current_branch" in
  "feature/"*)
    if [[ $remote_branch == *"production"* ]] || [[ $remote_branch == *"staging"* ]]; then
      echo "❌ Feature branches cannot be pushed directly to production or staging"
      exit 1
    fi
    ;;
  "development")
    if [[ $remote_branch == *"production"* ]]; then
      echo "❌ Development branch cannot be pushed directly to production"
      exit 1
    fi
    ;;
esac

# Check for signed commits on protected branches
if [[ $remote_branch == *"production"* ]] || [[ $remote_branch == *"main"* ]]; then
  unsigned_commits=$(git rev-list --format="%G?" HEAD~10..HEAD | grep -c "^N")
  if [ "$unsigned_commits" -gt 0 ]; then
    echo "❌ All commits must be signed for production deployment"
    exit 1
  fi
fi

echo "✅ Push validation passed"
EOF

chmod +x .git/hooks/pre-push
```

**Success Criteria:**
- Custom workflow addresses all scenario requirements
- Proper environment isolation and promotion
- Feature flag integration works correctly
- Compliance requirements met (signed commits, audit trail)
- Team collaboration features implemented

---

## 🔍 **Interactive Learning Labs**

### 🎯 **Lab 1: Git Bisect Detective**

Find the commit that introduced a bug using Git bisect.

**Setup:**
```bash
# Create a series of commits with a hidden bug
git checkout -b lab/bisect-practice

for i in {1..10}; do
    if [ $i -eq 7 ]; then
        # Introduce a bug in commit 7
        echo "function buggyFunction() { return null.property; }" >> src/utils/helper.js
    else
        echo "// Good commit $i" >> src/utils/helper.js
    fi
    git add .
    git commit -m "commit $i: add functionality"
done
```

**Your Mission:**
Use `git bisect` to find the exact commit that introduced the bug.

**Solution Process:**
```bash
# Start bisect
git bisect start

# Mark current state as bad
git bisect bad

# Mark a known good state
git bisect good HEAD~10

# Git will checkout commits for you to test
# Test each commit:
node -c src/utils/helper.js  # Check syntax

# Mark as good or bad
git bisect good  # or git bisect bad

# Continue until Git identifies the problematic commit
# When done:
git bisect reset
```

### 🎯 **Lab 2: Git Worktree Management**

Practice working with multiple branches simultaneously.

**Setup and Practice:**
```bash
# Create multiple worktrees for parallel development
git worktree add ../feature-a development
git worktree add ../feature-b development
git worktree add ../hotfix-branch production

# Work in different directories simultaneously
cd ../feature-a
# ... work on feature A ...

cd ../feature-b  
# ... work on feature B ...

cd ../hotfix-branch
# ... work on hotfix ...

# Return to main worktree
cd ../git-advanced-practice

# List all worktrees
git worktree list

# Remove worktrees when done
git worktree remove ../feature-a
git worktree remove ../feature-b
git worktree remove ../hotfix-branch
```

---

## 🎯 **Real-World Projects**

### 🚀 **Project 1: Open Source Contribution Simulation**

**Objective**: Simulate contributing to an open source project

**Scenario**: You want to contribute a feature to an open source project.

**Steps:**
1. Fork a repository (simulate with local clone)
2. Create feature branch following project conventions
3. Implement feature with proper tests and documentation
4. Create pull request with proper description
5. Address code review feedback
6. Handle merge conflicts with upstream changes

### 🚀 **Project 2: Multi-Repository Management**

**Objective**: Manage related repositories as a unit

**Scenario**: You have a microservices project with multiple repositories that need coordinated releases.

**Implementation:**
```bash
# Create structure for multi-repo project
mkdir microservices-project
cd microservices-project

# Clone multiple repositories
git clone <user-service-url>
git clone <payment-service-url>
git clone <notification-service-url>

# Create management scripts
cat > update-all.sh << 'EOF'
#!/bin/bash
for dir in */; do
  if [ -d "$dir/.git" ]; then
    echo "Updating $dir"
    cd "$dir"
    git fetch --all
    git checkout main
    git pull origin main
    cd ..
  fi
done
EOF

cat > release-all.sh << 'EOF'
#!/bin/bash
VERSION=$1
if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

for dir in */; do
  if [ -d "$dir/.git" ]; then
    echo "Releasing $dir version $VERSION"
    cd "$dir"
    git checkout main
    git tag -a "v$VERSION" -m "Release version $VERSION"
    git push origin --tags
    cd ..
  fi
done
EOF

chmod +x update-all.sh release-all.sh
```

---

## ✅ **Solutions and Explanations**

### 🎯 **Exercise 1 Solution: Interactive Rebase**

**Expected Result:**
```bash
git log --oneline -5
# Should show something like:
# abc123 feat: implement user authentication with bcrypt
# def456 feat: add authentication middleware and validation
```

**Key Learning Points:**
- `squash` combines commits but keeps all commit messages
- `fixup` combines commits but discards the fixup commit message
- `reword` allows changing commit messages
- `drop` completely removes commits from history

### 🎯 **Exercise 2 Solution: Cherry-picking**

**Expected Commands:**
```bash
git checkout feature/database
git log --oneline feature/api-endpoints
git cherry-pick <user-endpoints-commit>
git cherry-pick <health-check-commit>
# Skip the admin endpoint commit for security
```

**Key Learning Points:**
- Cherry-picking allows selective integration
- Always review what you're cherry-picking
- Consider security implications of commits

### 🎯 **Exercise 5 Solution: Git Hooks**

**Expected Behavior:**
- Pre-commit hook blocks commits with console.log
- Commit-msg hook enforces conventional commits
- Quality gates prevent low-quality code

**Key Learning Points:**
- Hooks enable automated quality control
- Team standards can be enforced automatically
- Hooks should be shared across the team

---

## 🏆 **Mastery Assessment**

### ✅ **Skills Checklist**

**Bronze Level (Completed ✅)**
- [ ] Interactive rebase proficiency
- [ ] Cherry-picking across branches  
- [ ] Advanced stashing techniques
- [ ] Basic conflict resolution

**Silver Level (Completed ✅)**
- [ ] Complex merge conflict resolution
- [ ] Git hooks implementation
- [ ] Repository maintenance
- [ ] Performance optimization

**Gold Level (Completed ✅)**
- [ ] Complete workflow implementation
- [ ] Large repository management
- [ ] Team collaboration patterns
- [ ] Release management

**Platinum Level (Completed ✅)**
- [ ] Custom workflow design
- [ ] Advanced troubleshooting
- [ ] Multi-repository coordination
- [ ] Expert-level problem solving

---

## 🎉 **Congratulations!**

You've completed the advanced Git exercises! You now have hands-on experience with:

- ✅ Advanced Git operations and workflows
- ✅ Complex problem-solving scenarios  
- ✅ Professional development practices
- ✅ Team collaboration techniques
- ✅ Repository management and optimization

**Next Steps:**
1. Apply these skills in real projects
2. Share knowledge with your team
3. Continue exploring Git's advanced features
4. Move on to [Git Best Practices](./05-git-best-practices.md)

---

**🚀 You're now a Git expert! Keep practicing and sharing your knowledge! 🚀**

---

*Part of Day 5 - Git Advanced | DevOps Zero to Intermediate Journey*