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

if [ -z $instance ]; then
    exit 0
fi


playerctl -p $instance metadata --format "$(get_status_icon $instance){{artist}} - {{title}} [{{playerName}}]"
