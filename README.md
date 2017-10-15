emacs-configuration
===================

My personal emacs init and config files

## Preparing

Ensure existing emacs configuration is backed up somewhere

```bash
mv ~/.emacs ~/.emacs.bak
mv ~/.emacs.d ~/.emacs.d.bak
```

## Cloning

```bash
git clone https://www.github.com/willkill07/emacs-configuration ~/.emacs.d
cd ~/.emacs.d
git submodule update --init --recursive
```

## Installation

```bash
pushd ~/.emacs.d/ycmd
./build.py --clang-completer
```

## Features

* `ycmd` and `company-mode` for autocomplete
* support for `.clang-format` and `.clang_complete` files
* `clang-format` for automatic code formatting
* `flycheck` for compilation errors and warnings
* beautification of code with `rainbow-delimiters` and `rainbow-identifiers`
* `modern-cpp-font-lock` for improving syntax coloring with modern c++
* automatic setup and installation of all packages (once `ycmd` is installed)
