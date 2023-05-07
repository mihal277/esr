#!/bin/bash

set -e

# build image
docker build -t esr .

# download assets
docker run --rm -v "$(pwd):/esr" esr bash download_dataset_and_checkpoints.sh