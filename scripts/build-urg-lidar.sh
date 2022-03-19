#!/bin/bash

echoerr() { echo "$@" 1>&2; }
blockmsg() { echoerr ""; echoerr "$@"; }

GIT_REPO="https://github.com/huskyroboticsteam/urg-lidar"
REPO_NAME="$(basename $GIT_REPO)"

# The git tag to use when checking out; uses the first argument of the script if set, and
# defaults to v1.2.5-2 if not.
TAG="${1:-v1.2.5-2}"
if [ -z $1 ]; then
    echoerr "No argument given; defaulting to $TAG"
fi

echoerr "Building version at tag $TAG"

BUILD_DIR="${BUILD_DIR:-/tmp/}"
OUTPUT_DIR="${OUTPUT_DIR:-$(readlink -f .)}"
blockmsg "Building in $BUILD_DIR and outputting binary to $OUTPUT_DIR"
echoerr "  (To change, set BUILD_DIR and OUTPUT_DIR, respectively)"
if [ -z $NOSLEEP ]; then
    blockmsg "  CTRL+C in the next 5 seconds if this is incorrect"
    sleep 5
fi

blockmsg "Cloning repo \"$GIT_REPO\"..."
cd "$BUILD_DIR"
if [ -d "$REPO_NAME" ]; then
    echoerr "$REPO_NAME already exists, skipping clone..."
else
    git clone "$GIT_REPO" "$REPO_NAME"
fi
cd "$REPO_NAME"

blockmsg "Switching to tag $TAG"
git checkout "$TAG"

blockmsg "Running CMake build..."
mkdir -p build && cd build
cmake ..
cmake --build . -j$(nproc)

blockmsg "Running CPack to generate DEB file..."
cpack -G DEB

blockmsg "Copying DEB files to \"$OUTPUT_DIR\"..."
cp -fr *.deb "$OUTPUT_DIR"

blockmsg "Cleaning up..."
rm -rf "$BUILD_DIR/$REPO_NAME"
echoerr "Done!"
