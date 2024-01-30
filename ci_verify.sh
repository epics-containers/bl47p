#!/bin/bash

# CI to verify all the IOC instances specified in this repo
# Domain agnostic - this script is generic for all beamlines/domains

THIS=$(dirname ${0})
set -e

for app in ${THIS}/apps/*
do
    # Skip if subfolder has no config to validate
    if [ ! -d "${ioc}/config" ]; then
        continue
    fi

    ec ioc validate "${ioc}"
done

