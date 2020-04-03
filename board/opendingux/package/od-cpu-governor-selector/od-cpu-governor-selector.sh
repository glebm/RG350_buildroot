#!/bin/sh

set -e

CPU_DIR='/sys/devices/system/cpu/cpu0/cpufreq'

AVAILABLE="$(cat "$CPU_DIR/scaling_available_governors")"
CURRENT="$(cat "$CPU_DIR/scaling_governor")"
CUR_FREQ="$(cat "$CPU_DIR/cpuinfo_cur_freq")"
MIN_FREQ="$(cat "$CPU_DIR/cpuinfo_min_freq")"
MAX_FREQ="$(cat "$CPU_DIR/cpuinfo_max_freq")"

# Uncomment this for testing:
# AVAILABLE="ondemand performance powersave userspace"
# CURRENT=powersave
# CUR_FREQ=500000
# MIN_FREQ=332000
# MAX_FREQ=996000

DLG_GOV_OPTS_FILE=/tmp/gov-opts
rm -f "$DLG_GOV_OPTS_FILE"
DLG_GOV_OPTS_SIZE=0
for governor in $AVAILABLE; do
  if [ "$governor" = userspace ]; then
    continue;
  fi

  echo "$governor" >> "$DLG_GOV_OPTS_FILE"
  desc="$governor"
  if [ "$governor" = performance ]; then
    desc='"Run at the maximum frequency"'
  elif [ "$governor" = powersave ]; then
    desc='"Run at the minimum frequency"'
  elif [ "$governor" = ondemand ]; then
    desc='"Scale the frequency dynamically"'
  fi
  echo "$desc" >> "$DLG_GOV_OPTS_FILE"

  DLG_GOV_OPTS_SIZE=$((DLG_GOV_OPTS_SIZE + 1))
done

dialog \
  --no-cancel --no-collapse \
  --title 'CPU Governor' \
  --ok-label 'Press START' \
  --default-item "$CURRENT" \
  --menu "Frequency: cur=$CUR_FREQ min=$MIN_FREQ max=$MAX_FREQ" \
  $((7 + DLG_GOV_OPTS_SIZE)) 60 $((DLG_GOV_OPTS_SIZE)) \
  --file "$DLG_GOV_OPTS_FILE" \
  2>/tmp/dlg-result
SELECTED="$(cat /tmp/dlg-result)"
rm -f /tmp/dlg-result
rm -f "$DLG_GOV_OPTS_FILE"

if [ -z "$SELECTED" ]; then
  echo "No result from dialog"
  exit 1
fi

if [ "$SELECTED" = "$CURRENT" ]; then
  echo "$SELECTED is already the current governor"
else
  echo "Changing governor from $CURRENT to $SELECTED"
  echo "$SELECTED" > "$CPU_DIR/scaling_governor"
fi
