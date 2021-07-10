#!/bin/bash
set -e
set -o pipefail

./patch.sh
./build.sh