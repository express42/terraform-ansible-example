#!/usr/bin/env bash

set -euo nounset -o pipefail
# cd to script dir
cd $( dirname "${BASH_SOURCE[0]}" )
# set inventory dir
INVENTORY_DIR="$( cd ../terraform/.terraform && pwd )"
ati "$@" --root $INVENTORY_DIR
