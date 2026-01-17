#  Bash Scripts Collection

Welcome to my **Bash Scripts** repository! This repository serves as a centralized collection of shell scripts designed for system administration, DevOps tasks, automation, and general utility usage on Linux/Unix environments.

## 📂 Repository Structure

Each script in this repository is **self-contained**. This means you don't need to look for external documentation; every file includes a standard header with:
- **Description:** What the script does.
- **Usage Guide:** Step-by-step instructions.
- **Syntax & Examples:** How to run it properly.

### 📜 List of Scripts

| Script Name | Description |
| :--- | :--- |
| `log_compressor.sh` | Scans a directory for `.log` files and compresses them using `gzip`. |
| `backup.sh` | Automates directory backup with logging and 7-day retention policy. Creates a .tar.gz archive of the source directory. |
| `...` | *More scripts will be added over time.* |

---

## 🚀 Getting Started

### 1. Clone the Repository
Clone this repository to your local machine to access the scripts.

```bash
git clone [https://github.com/utkuuzunhuseyin/bash-scripts.git]
cd Bash-Scripts
```
---

### 2. Make Scripts Executable
By default, scripts might not have execution permissions after cloning. You must grant permission before running them.
```bash
chmod +x *.sh
```
Or for a specific script:
```bash
chmod +x log_compressor.sh
```
---

### 3. Usage
To run a script, simply execute it from the terminal.

#### General Syntax:
```bash
./<script_name>.sh
```

#### Syntax with Multiple Arguments: Some scripts require specific inputs (like source path, destination, filename, etc.). In the script code, these inputs map to positional parameters:

* First argument → $1

* Second argument → $2

* Third argument → $3 (and so on...)

```bash
./<script_name>.sh [arg1] [arg2] [arg3] ...
```

Example Usage (log_compressor.sh): In this example, /var/log is the first argument ($1).
```bash
./log_compressor.sh /var/log
```
---

### 🤝 Contributing
Contributions are welcome! If you have a script that solves a common problem or want to improve an existing one:

1- Fork the repository.

2- Create a new branch (git checkout -b feature/new-script).

3- Commit your changes.

4- Push to the branch and open a Pull Request.

---

### 👤 Author

Utku Uzunhüseyin

* GitHub: @utkuuzunhuseyin
