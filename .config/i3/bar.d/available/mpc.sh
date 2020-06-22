#!/bin/bash
output="$(mpc --host=nerdnas.broadband)"
media="$(mpc --host=nerdnas.broadband -f '%artist% - %title%' current)"

if [[ "$media" =~ "MPD error:" ]]; then
  exit 0
else
  icon=" "
  if [[ "$output" =~ "[playing]" ]]; then
    icon="⯈"
  elif [[ "$output" =~ "[paused]" ]]; then
    icon="⏸"
  else
    exit 0
  fi
  echo $icon $media
fi


