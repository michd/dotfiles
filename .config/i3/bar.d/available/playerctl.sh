#!/bin/bash

get_playing_instance() {
    local is_done=0

    for p in $(playerctl -l); do
        if [ $(playerctl status -p $p 2> /dev/null) = "Playing" ]; then
            echo $p
            is_done=1
            break
        fi
    done

    if [ $is_done -ne 1 ]; then
        for p in $(playerctl -l); do
            if [ ! $(playerctl status -p $p 2> /dev/null) = "Stopped" ]; then
                echo $p
                break
            fi
        done
    fi
}

get_status_icon() {
    local instance=$1

    case $(playerctl status -p $instance 2> /dev/null) in
        "Playing") echo "▶ ";;
        "Paused") echo "⏸ ";;
    esac
}

instance=$(get_playing_instance)

if [ ! -z $instance ]; then
    playerctl -p $instance metadata --format "$(get_status_icon $instance){{artist}} - {{title}} [{{playerName}}]"
    exit 0
fi

# If we get here, there was no playerctl instance, check for mpd instead.

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
  echo "$icon $media ($pos) [mpd]"
fi

