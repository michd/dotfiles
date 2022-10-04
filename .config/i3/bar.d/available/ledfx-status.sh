#!/bin/bash

status=$(systemctl --user is-active ledfx.service)
if [ "$status" = "active" ]; then
    echo "🎶🌟"
fi
