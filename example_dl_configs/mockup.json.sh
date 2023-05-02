#!/bin/bash

# Prints out JSON for mockup model and template (test purpose)

scriptdir=$(dirname $(readlink -e $BASH_SOURCE))

echo '{
    "models": [{
        "url": "file://'"$scriptdir"'/mockup_model.bin",
        "name": "mockup"
    }],
    "templates": [{
        "name": "template1",
        "content": "this is the text content of the template"
    }, {
        "name": "template2",
        "content": "blabla"
    }]
}'
