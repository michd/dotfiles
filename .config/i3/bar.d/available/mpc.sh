#!/bin/bash
output="$(mpc --host=nerdnas.broadband status)"
media=""
play_status=""
settings=""

i=0
while read line; do
  case $i in
    0) media=$line;;
    1) play_status=$line;;
    2) settings=$line;;
  esac

  i=$((i+1))
done < <(echo "$output")

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

  pos=$(echo "$play_status" | awk '{ print $3 }')
  echo "$icon $media ($pos)"
fi


