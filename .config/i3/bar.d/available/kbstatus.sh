#!/bin/bash

capsLockSearch="Caps\s*Lock:\s*on"
numLockSearch="Num\s*Lock:\s*on"

is_on() {
  if [ -z "$(xset -q | grep $1)" ]; then
    echo false
  else
    echo true
  fi
}

if [ "$(is_on $numLockSearch)" = true ]; then
  echo -n "[1]"
fi

if [ "$(is_on $capsLockSearch)" = true ]; then
  if [ "$(is_on $numLockSearch)" = true ]; then
    echo -n " "
  fi
  echo -n "[A]"
fi

