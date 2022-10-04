#!/bin/bash

sink=$(pactl list short sinks | grep `pactl info | grep "Default Sink:" | cut -d " " -f 3` | cut -f 1)

if [ "$sink" = "0" ]; then
  echo "🔉"
elif [ "$sink" = "1" ]; then
  echo "🎧"
elif [ "$sink" = "2" ]; then
  echo "🔉+🎧"
fi

