#!/bin/bash

# KERNEL=="card0", ACTION=="change", SUBSYSTEM=="drm", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/patrick/.Xauthority", RUN+="/opt/scripts/display.sh"

built_in="$(xrandr | grep " connected" | grep "eDP" | awk '{print $1}')"
ext_display="$(xrandr | grep " connected" | grep -v "eDP-1" | awk '{print $1}')"

if [[ -n "$ext_display" ]]; then
	xrandr --output $built_in --auto --output $ext_display --auto --right-of eDP-1
else
	xrandr --output $built_in --auto 
	xrandr | grep disconnected | awk '{print $1}' | xargs -I {} xrandr --output {} --off
fi
