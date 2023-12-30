#!/bin/bash
# This is a script to automate brightness control adjustment on laptops.
# I have it mapped to Win+F4 for down and Win+F5 for up in i3 (as native brightness keys dont work).
# It should be accompanied by the udev rule in /etc/udev/rules.d/99-brightness-control.rules
# which you can find in the rules/ folder.
#
# Usage is "./brightness_control.sh [up|down]"

# Set the path to the brightness file
brightness_file="/sys/class/backlight/intel_backlight/brightness"

# Define the minimum and maximum brightness values
min_brightness=50
max_brightness=400

# Read the current brightness value
current_brightness=$(cat $brightness_file)

# Function to adjust brightness
adjust_brightness() {
  local direction=$1
  local step=50

  if [ "$direction" == "up" ]; then
    new_brightness=$((current_brightness + step))
  elif [ "$direction" == "down" ]; then
    new_brightness=$((current_brightness - step))
  else
    echo "Invalid argument. Use 'up' or 'down'."
    exit 1
  fi

  # Ensure the new brightness is within the specified range
  if [ $new_brightness -gt $max_brightness ]; then
    new_brightness=$max_brightness
  elif [ $new_brightness -lt $min_brightness ]; then
    new_brightness=$min_brightness
  fi

  # Update the brightness
  echo $new_brightness > $brightness_file
  echo "Brightness adjusted to $new_brightness."
}

# Check if an argument is provided
if [ $# -eq 1 ]; then
  adjust_brightness $1
else
  echo "Usage: $0 [up|down]"
  exit 1
fi

