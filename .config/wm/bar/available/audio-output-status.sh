#!/bin/bash

sink=$(pactl info | grep "Default Sink")

if [[ "$sink" == *"SteelSeries"* ]]; then
  echo "🎧"
elif [[ "$sink" == *"a2dp-sink"* ]]; then
    echo "BT"
elif [[ "$sink" == *"Focusrite"* ]]; then
  echo "🔉"
fi

