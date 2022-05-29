#!/bin/bash

echoerr() { echo "$@" 1>&2; }
blockmsg() { echoerr ""; echoerr "$@"; }

if [ -z $1 ]; then
	echoerr "Usage: $0 <repo url> [tag]"
	exit 1
fi
GIT_REPO="$1"
REPO_NAME="$(basename $GIT_REPO)"

# Location of ARM toolchain file
SCRIPTS_DIR="$(dirname "$(readlink -f ${BASH_SOURCE})")"
ARM_TOOLCHAIN_FILE="${SCRIPTS_DIR}/arm-toolchain.cmake"

# The git tag to use when checking out; uses the first argument of the script if set, and
# defaults to default branch if not.
TAG="$2"
if [ -z $TAG ]; then
    echoerr "No tag given; building from default branch"
else
	echoerr "Building version at tag $TAG"
fi

BUILD_DIR="${BUILD_DIR:-/tmp/}"
BASE_OUTPUT_DIR="${OUTPUT_DIR:-$(readlink -f .)}"
if [ -n "$BUILD_ARM" ]; then
    blockmsg "Cross-compiling for ARM..."
    OUTPUT_DIR="${BASE_OUTPUT_DIR}/arm"
else
    blockmsg "Compiling for native platform..."
    OUTPUT_DIR="${BASE_OUTPUT_DIR}/x86_64"
fi 
echoerr "Building in $BUILD_DIR and outputting binary to $OUTPUT_DIR"
echoerr "  (To change, set BUILD_DIR and OUTPUT_DIR, respectively)"
if [ -z $NOSLEEP ]; then
    blockmsg "  CTRL+C in the next 5 seconds if this is incorrect"
    sleep 5
fi

blockmsg "Cloning repo \"$GIT_REPO\"..."
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"
if [ -d "$REPO_NAME" ]; then
    echoerr "$REPO_NAME already exists, skipping clone..."
else
    git clone --recursive "$GIT_REPO" "$REPO_NAME"
fi
cd "$REPO_NAME"

if [ -n "$TAG" ]; then
	blockmsg "Switching to tag $TAG"
	git checkout "$TAG"
fi

blockmsg "Running CMake build..."
mkdir -p build && cd build
if [ -n "$BUILD_ARM" ]; then
    cmake -DCMAKE_TOOLCHAIN_FILE="${ARM_TOOLCHAIN_FILE}" ..
else
    cmake ..
fi
cmake --build . -j$(nproc)

blockmsg "Running CPack to generate DEB file..."
if [ -n "$KEEP_MAINTAINER" ]; then
	cpack -G DEB
else
	cpack -G DEB \
		  -D CPACK_DEBIAN_PACKAGE_MAINTAINER="Husky Robotics Team <uwrobots@uw.edu>"
fi

blockmsg "Copying DEB files to \"$OUTPUT_DIR\"..."
mkdir -p "$OUTPUT_DIR"
cp -fr *.deb "$OUTPUT_DIR"

blockmsg "Cleaning up..."
rm -rf "$BUILD_DIR/$REPO_NAME"
echoerr "Done!"
