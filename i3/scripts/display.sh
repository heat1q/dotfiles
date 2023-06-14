#!/bin/bash

# KERNEL=="card0", ACTION=="change", SUBSYSTEM=="drm", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/patrick/.Xauthority", RUN+="/opt/scripts/display.sh"

if [[ "$DISPLAY_LOCK" == "locked" ]]; then
    exit 0
fi

export DISPLAY_LOCK=locked
action="$1"
built_in="$(xrandr | grep " connected" | grep "eDP" | awk '{print $1}')"
echo $built_in
ext_display="$(xrandr | grep " connected" | grep -v "eDP-1" | awk '{print $1}')"
echo $ext_display
if [[ "$action" == "add" ]]; then
	xrandr --output $built_in --auto --output $ext_display --auto --right-of eDP-1 >/dev/null
else
	xrandr --output $built_in --auto >/dev/null
	xrandr | grep disconnected | awk '{print $1}' | xargs -I {} xrandr --output {} --off >/dev/null
fi

sleep 5

# Set the lock to prevent multiple executions
export DISPLAY_LOCK=unlocked
