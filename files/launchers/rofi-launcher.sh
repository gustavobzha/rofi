#!/bin/bash

function launch() {
    dir=$1
    theme=$2

    if [[ -z $3 ]]; then
        run_command=drun
    else
        run_command=$3
    fi

    ## Run
    rofi \
        -show $run_command \
        -theme ${dir}/${theme}.rasi
}