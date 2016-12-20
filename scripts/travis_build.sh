#!/usr/bin/env bash
# Main build script. For now just initialises and invokes tup.

# Add the newly build tup to PATH
PATH=$PATH:$HOME/tup

pwd

# Initialise .tup directory
tup init

# Build
tup upd
