#!/usr/bin/env bash

set -euo nounset -o pipefail
INVENTORY_DIR="$( cd ../terraform/.terraform && pwd )"
ati "$@" --root $INVENTORY_DIR
