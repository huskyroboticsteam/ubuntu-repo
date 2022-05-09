#!/bin/bash

BUILD="$(dirname $0)/build-cmake.sh"
EMAIL="uwrobots@uw.edu"

URG_LIDAR_URL="https://github.com/huskyroboticsteam/urg-lidar"
RPLIDAR_URL="https://github.com/huskyroboticsteam/rplidar"
CATCH2_URL="https://github.com/catchorg/catch2"
UBLOX_URL="https://github.com/huskyroboticsteam/ublox-linux"
CAN_URL="https://github.com/huskyroboticsteam/HindsightCAN"
FROZEN_URL="https://github.com/serge-sans-paille/frozen"

if [[ -z $1 || "$1" == "urg-lidar" ]]; then "$BUILD" "$URG_LIDAR_URL" "v1.2.5-2"; fi
if [[ -z $1 || "$1" == "rplidar" ]]; then "$BUILD" "$RPLIDAR_URL" "v1.10.0-3"; fi
if [[ -z $1 || "$1" == "catch2" ]]; then "$BUILD" "$CATCH2_URL" "v2.13.7"; fi
if [[ -z $1 || "$1" == "ublox" ]]; then "$BUILD" "$UBLOX_URL" "v2.0.6-1"; fi
if [[ -z $1 || "$1" == "hindsightcan" ]]; then "$BUILD" "$CAN_URL" "v1.0.3"; fi
if [[ -z $1 || "$1" == "frozen" ]]; then "$BUILD" "$FROZEN_URL" "1.1.1"; fi

touch -t 197001010000.00 */*.deb

dpkg-scanpackages --multiversion . > Packages
gzip -k -f Packages

apt-ftparchive release . > Release
gpg --default-key "${EMAIL}" -abs -o - Release > Release.gpg
gpg --default-key "${EMAIL}" --clearsign -o - Release > InRelease
