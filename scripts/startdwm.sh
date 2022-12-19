cbatticon &
while true; do
   TIME="$( date +"%F %R:%S" )"
   OUT="$TIME"
   xsetroot -name "$OUT"

   sleep 1s    # Update time every minute
done &

# relaunch DWM if the binary changes, otherwise bail
csum=""
new_csum=$(sha1sum $(which dwm))
while true
do
    if [ "$csum" != "$new_csum" ]
    then
        csum=$new_csum
        #dwm
    else
        exit 0
    fi
    new_csum=$(sha1sum $(which dwm))
    sleep 0.5
done
