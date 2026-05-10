#!/bin/bash

is_on() {
  [ "$(cat /sys/class/leds/input*::$1/brightness | head -n1)" = "1" ]
}

if is_on numlock; then echo -n "[1]"; fi

if is_on capslock; then
  if is_on numlock; then; echo -n " "; fi
  echo -n "[A]"
fi