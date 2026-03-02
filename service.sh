#!/system/bin/sh
MODDIR=${0%/*}
CONFIG_FILE="$MODDIR/config.conf"

if [ -f "$CONFIG_FILE" ]; then
    SAVED_VALUE=$(cat "$CONFIG_FILE")
    if [[ "$SAVED_VALUE" =~ ^[0-9]+$ ]] && [ "$SAVED_VALUE" -ge 1 ] && [ "$SAVED_VALUE" -le 200 ]; then
        sysctl -w vm.swappiness=$SAVED_VALUE
        sh $MODDIR/update_desc.sh
    fi
fi