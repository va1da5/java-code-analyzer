# Find Bugs in Java Project

The tool decompiles Java WARs and JARs and provides Java code for review. Furthermore, it uses [Find Security Bugs](https://find-sec-bugs.github.io/) to automatically identify possible security issues.

## Requirements
- Docker
- Internet connection

## Preparation
- `./build.sh` will create a custom docker image with tools prepared

## Usage
- `./run.sh <project-path> <decompiled-code-path> <reports-path>`
- You can create a symbolic link to location covered by PATH variable, for example `sudo ln -s $PWD/run.sh /usr/local/bin/findsecbugs`


---
## Note
*Work is still in progress*