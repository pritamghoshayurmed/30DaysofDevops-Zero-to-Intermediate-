# Practice Exercises and Solutions

This file contains practice exercises to test your understanding of the concepts covered in the Shell Scripting, File Permissions, and Text Processing guides. Solutions are provided at the end of each section.

## Shell Scripting Exercises

### Exercise 1: User Greeting

Write a shell script that prompts the user for their name and then greets them.

### Exercise 2: File Backup

Write a script that creates a backup of a given file. The script should take the file path as an argument and create a copy with a `.bak` extension.

### Exercise 3: Number Guessing Game

Create a simple number guessing game. The script should generate a random number between 1 and 100, and the user has to guess it. Provide feedback on whether the guess is too high or too low.

---

### Shell Scripting Solutions

#### Solution 1: User Greeting

```bash
#!/bin/bash

read -p "What is your name? " name
echo "Hello, $name! Welcome to the world of shell scripting."
```

#### Solution 2: File Backup

```bash
#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <file_path>"
  exit 1
fi

if [ ! -f "$1" ]; then
  echo "Error: File not found at $1"
  exit 1
fi

cp "$1" "$1.bak"
echo "Backup of $1 created at $1.bak"
```

#### Solution 3: Number Guessing Game

```bash
#!/bin/bash

# Generate a random number between 1 and 100
target=$(( (RANDOM % 100) + 1 ))

echo "I'm thinking of a number between 1 and 100. Can you guess it?"

while true; do
  read -p "Your guess: " guess
  if ! [[ "$guess" =~ ^[0-9]+$ ]]; then
    echo "Please enter a valid number."
    continue
  fi

  if [ $guess -lt $target ]; then
    echo "Too low!"
  elif [ $guess -gt $target ]; then
    echo "Too high!"
  else
    echo "Congratulations! You guessed the number."
    break
  fi
done
```

## File Permissions Exercises

### Exercise 1: Set Permissions

What `chmod` command would you use to set the following permissions on a file named `app.sh`?
- Owner: read, write, execute
- Group: read, execute
- Others: read-only

### Exercise 2: Find World-Writable Files

Write a command to find all world-writable files in the `/var/log` directory.

---

### File Permissions Solutions

#### Solution 1: Set Permissions

You can use octal mode:
`chmod 754 app.sh`

Or symbolic mode:
`chmod u=rwx,g=rx,o=r app.sh`

#### Solution 2: Find World-Writable Files

`find /var/log -type f -perm -o=w`

## Text Processing Exercises

### Exercise 1: `grep`

Write a command to find all lines in `/etc/passwd` that use the `/bin/bash` shell.

### Exercise 2: `sed`

Write a `sed` command to replace all instances of "development" with "production" in a configuration file named `config.yaml`.

### Exercise 3: `awk`

Given a file `employees.txt` with the format `ID,Name,Department,Salary`, write an `awk` command to print the name and salary of all employees in the "Sales" department.

**employees.txt:**
```
101,John Smith,Sales,60000
102,Jane Doe,Engineering,80000
103,Peter Jones,Sales,65000
104,Susan Williams,Engineering,82000
```

---

### Text Processing Solutions

#### Solution 1: `grep`

`grep "/bin/bash" /etc/passwd`

#### Solution 2: `sed`

`sed -i 's/development/production/g' config.yaml`
*(Note: The `-i` option modifies the file in place. Be careful when using it.)*

#### Solution 3: `awk`

`awk -F, '$3 == "Sales" {print $2, $4}' employees.txt`
*(Note: `-F,` sets the field separator to a comma.)*
