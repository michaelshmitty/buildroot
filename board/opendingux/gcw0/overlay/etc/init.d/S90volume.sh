#!/bin/sh
#
# Simple script to load/store ALSA parameters (volume...)
#

VOLUME_STATEFILE=/usr/local/etc/volume.state
CONTROL=PCM
VOLUME_STATEFILE_HEADPHONES=/usr/local/etc/volume.headphones.state
CONTROL_HEADPHONES=Headphones

case "$1" in
  start)
    echo "Loading sound volume..."
    if [ -f $VOLUME_STATEFILE ]; then
      /usr/bin/amixer set $CONTROL `cat $VOLUME_STATEFILE`
    fi
    if [ -f $VOLUME_STATEFILE_HEADPHONES ]; then
      /usr/bin/amixer set $CONTROL_HEADPHONES `cat $VOLUME_STATEFILE_HEADPHONES`
    fi
    ;;
  stop)
    echo "Storing sound volume..."
    amixer get $CONTROL | sed -n 's/.*Front .*: Playback \([0-9]*\).*$/\1/p' | paste -d "," - - > $VOLUME_STATEFILE
    amixer get $CONTROL_HEADPHONES | sed -n 's/.*Front .*: Playback \([0-9]*\).*$/\1/p' | paste -d "," - - > $VOLUME_STATEFILE_HEADPHONES
    ;;
  *)
    echo "Usage: $0 {start|stop}"
    exit 1
esac

exit $?

