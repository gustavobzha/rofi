#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Launcher (Modi Drun, Run, File Browser, Window)
#
## Available Styles
#
## style-1     style-2     style-3     style-4     style-5
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/../rofi-launcher.sh"

dir="$HOME/.config/rofi/launchers/type-5"
theme='style-1'
custom_command=$1

## Run
launch $dir $theme $custom_command 