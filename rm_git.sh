#!/usr/bin/env bash

# find just the top level dirs excluding .
find .  -depth -maxdepth 1 -mindepth 1 -type d -exec rm -rf {}/.git \;
