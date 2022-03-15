# Husky Robotics Ubuntu Package Repository

Our rover codebase depends on many third-party libraries (mostly for
sensor drivers) that would normally have to be compiled and installed
from source; this repository allows Ubuntu users to install these
libraries via the system's `apt` package manager.

## Setup Instructions
1. Install cURL and `wget`, used to download files:
```bash
sudo apt install curl wget
```
2. Add the public key used to verify the packages' signatures:
```bash
curl -s --compressed "https://huskyroboticsteam.github.io/ubuntu-repo/KEY.gpg" | sudo apt-key add -
```

3. Add the repository to your system's list of software sources:
```bash
sudo wget -P /etc/apt/sources.list.d "https://huskyroboticsteam.github.io/ubuntu-repo/husky_robotics.list"
```

4. Update the package catalog:
```bash
sudo apt update
```

5. **Done!** You should now be able to install packages from the
   repository with `sudo apt install <package>`.
   
## Removing the Repository
If at some point in the future you decide you no longer want to get
packages from this repository, you can simply delete the
`/etc/apt/sources.list.d/husky_robotics.list` file (or rename it to
something that does not end in `.list`).
