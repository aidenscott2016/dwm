#! /bin/env sh
while true; do
   BATTERY="$(sudo cat /sys/class/power_supply/BAT0/capacity)"
   TIME="$( date +"%F %R:%S" )"
   OUT="$TIME $BATTERY"
   xsetroot -name "$OUT"

   sleep 1s    # Update time every minute
done &
