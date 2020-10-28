# Chipyard-build

This is a Dockerfile for a environment that can run the Chipyard building
framework.

## Overview

The environment relies on the container
`registry.gitlab.com/knipegp/vemu/golang-riscv-gcc:0.1.0`, pushed to GitLab.
The Dockerfile can be found [here](https://gitlab.com/knipegp/riscv-build).

## Usage

### Environment

`docker pull registry.gitlab.com/akita/riscv/chipyard-build:0.1.0`

The intended usage for the environment is to build Chipyard configurations on
the host system. The environment needs to be able to target files and generate
files on the host file system and the generated files should have the same
permissions as the current user. Running this Docker container with
[run\_container.sh](https://github.com/knipegp/docker-base) and using the
`--volume-path` flag will solve both of these problems.

### Running

This environment is capable of building a Verilator simulation of a BOOM core.
To build the simulation, go to `sims/verilator` and run
`make CONFIG=SmallBoomConfig`.

## Notes

Building the Verilator simulation can fail if the repository is dirty. Running
`git reset --hard HEAD` and `git clean -fxd` does not seem to fix the problem.
Re-cloning the Chipyard repository, checking out the desired tag, and rerunning
`scripts/init-submodules-no-riscv-tools.sh` to initialize the repository before
starting a build is a good way to ensure that the build succeeds.
