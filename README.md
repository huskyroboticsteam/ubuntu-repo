# Husky Robotics Ubuntu Package Repository

## User Instructions

Our rover codebase depends on many third-party libraries (mostly for
sensor drivers) that would normally have to be compiled and installed
from source; this repository allows Ubuntu users to install these
libraries via the system's `apt` package manager.

### Setup Instructions
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
   
### Removing the Repository
If at some point in the future you decide you no longer want to get
packages from this repository, you can simply delete the
`/etc/apt/sources.list.d/husky_robotics.list` file (or rename it to
something that does not end in `.list`).

## Admin Instructions (For SW Lead)

These instructions will indicate how to create new builds if dependencies have changed.

If you haven't already, add the HRT gpg key to your keyring. First, download the gpg key from the leadership drive, located at `/Software/uwrobots-pkg-key.gpg`. Then, import it.

```bash
gpg --import <path to key>
```

It will prompt you for a password, which you can find in the "Accounts & Passwords" spreadsheet in the leadership drive, under the name "Software GPG Key".

You will need to cross-compile packages, since we have both x86\_64 and ARM systems. If your machine is x86\_64, then install the ARM toolchains:
```bash
sudo apt-get install gcc-aarch64-linux-gnu
```

If your system is ARM, then you might be screwed, since I'm not sure if the scripts support it. There's probably some way to do it though!

If you need to build a specific version (indicated by a tag in the dependency repo) then edit `scripts/build-packages.sh` and set the second command of `BUILD` (in the if-else tree) to the required tag. If there is no second argument, it will build the default branch.

If you want to rebuild all packages:
```bash
./scripts/build-packages.sh
```

If you want to build a specific package:
```bash
./scripts/build-packages.sh <package name> # look inside the script to see package names
```

To cross-compile for ARM, prepend `BUILD_ARM="true"` to the command, i.e.:
```bash
BUILD_ARM="true" ./scripts/build-packages.sh hindsightcan
```

You may have to re-enter the password while building.

Now commit and push, and the dependencies should be updated! Note that all dev machines will need to update their version of these dependencies.\

