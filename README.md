# Vinix

Vinix is an effort to write a modern, fast, and useful operating system in [the V programming language](https://vlang.io).

Join the [Discord chat](https://discord.gg/qV9G4cVJpb).

## Download the ISO

You can get a continuously updated ISO of Vinix [here](https://builds.vinix-os.org/repos/files/vinix/latest/vinix.iso).

## What is Vinix all about?

- Keeping the code as simple and easy to understand as possible, while not sacrificing
performance and prioritising code correctness.
- Making a *usable* OS which can *run on real hardware*, not just on emulators or
virtual machines.
- Targetting modern 64-bit architectures, CPU features, and multi-core computing.
- Maintaining good source-level compatibility with Linux to allow to easily port programs over.
- Exploring V capabilities in bare metal programming and improving the compiler in response to the uncommon needs of bare metal programming.
- Having fun.

![Reference screenshot](/screenshot.png?raw=true "Reference screenshot")

## Roadmap

- [x] mlibc
- [x] bash
- [x] builds.vinix-os.org
- [x] gcc
- [x] g++
- [X] V
- [x] nano
- [ ] storage drivers
- [ ] ext2
- [ ] Wayland compositor
- [ ] V-UI
- [ ] network
- [ ] Intel HD graphics driver (linux port)

## Build instructions

### OS-agnostic build prerequisites

The following is an OS-agnostic list of packages needed to build Vinix. Skip to a paragraph for your host OS if there is any.

`GNU make`, `GNU patch`, `GNU tar`, `GNU gzip`, `GNU coreutils`, `git`, `subversion`, `mtools`, `meson`, `ninja`, `m4`, `texinfo`, `pkg-config`, `groff`, `gettext`, `autopoint`, `bison`, `flex`, `help2man`, `gperf`, `gcc`, `nasm`, `python3`, `pip3`, `python3-mako`, `wget`, `xorriso`, and `qemu` to test it.

### Build prerequisites for Ubuntu, Debian, and derivatives
```bash
sudo apt install build-essential nasm git subversion mtools meson m4 texinfo pkg-config groff gettext autopoint bison flex help2man gperf python3 python3-pip python3-mako wget xorriso qemu-system-x86
```

### Build prerequisites for Arch Linux and derivatives
```bash
sudo pacman -S base-devel nasm git subversion mtools meson m4 texinfo pkgconf groff gettext bison flex help2man gperf python python-pip python-mako wget xorriso qemu-arch-extra
```

### Building Vinix on macOS

This build system does not officially support macOS. Run this in an x86_64 Linux VM
or real hardware.

### Installing xbstrap

It is necessary to fetch `xbstrap` from `pip3`:
```bash
pip3 install --user xbstrap
```

### Building the distro

To build the distro which includes the cross toolchain necessary
to build kernel and ports, run:

```bash
make distro
```

This step will take a while.

### Building the kernel and image

Simply run
```bash
make
```

### To test

In Linux, if KVM is available, run with
```bash
make run-kvm
```

In macOS, if hvf is available, run with
```bash
make run-hvf
```

To run without any acceleration, run with
```bash
make run
```
