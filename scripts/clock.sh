#! /bin/sh
cbatticon &
while true; do
   TIME="$( date +"%F %R:%S" )"
   OUT="$TIME"
   xsetroot -name "$OUT"

   sleep 1s    # Update time every minute
done &
