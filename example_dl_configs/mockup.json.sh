#!/bin/bash

# prints out json for mockup model (test purpose)

scriptdir=$(dirname $(readlink -e $BASH_SOURCE))

echo "[{
        \"url\":\"file://$scriptdir/mockup_model.bin\",
        \"name\":\"mockup\",
        \"template\": \"...\"
}
]"