#!/bin/sh
echo 🔆 $(LC_ALL=c /usr/bin/printf "%.*f\n" 0 $(xbacklight))%
