#!/bin/sh

# This status script combines available bar executables with i3status output
# Procedure for adding something to the status bar:
# - Create an executable file that outputs what you want to add
# - Put it in .bar.d/
# You're done.
# I like to put the actual scripts in bar.d/available and then create a symlink
# to files I want to use in the parent directory. Simply activate/deactivate
# "plugins" if you will.

confPath="$HOME/.config/i3/"
barScriptPath="$confPath/bar.d/"

# Echos all output from executable files in bar.d/, concatenating it.
assemble() {
  for f in $barScriptPath/*; do
    # If it's a regular file and it's executable
    if [ -f $f ] && [ -x $f ]; then
      # Get its output
      local output=$($f)
      # If output is non-blank, echo it + delimiter
      if [ ! -z "$output" ]; then
        echo -n "$output ︴"
      fi
    fi
  done
}

# Continuously read i3status output
i3status -c "$confPath/i3status.conf" | while :
do
  read line
  # Concatenate script output before it
  echo "$(assemble)$line"
done

