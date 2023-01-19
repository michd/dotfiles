#!/bin/bash

sink=$(pactl info | grep "Default Sink")

if [[ "$sink" == *"SteelSeries"* ]]; then
  echo "🎧"
elif [[ "$sink" == *"Focusrite"* ]]; then
  echo "🔉"
fi

