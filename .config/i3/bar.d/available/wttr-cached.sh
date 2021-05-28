#!/bin/bash
confFile=".config/wttrcfg"

location=""
updateIntervalSeconds=0
lastUpdate=0
lastWeather=""

loadConfig() {
  if [ ! -f $confFile ]; then
    echo "Conf file not found"
    exit 1
  fi

  local i=0

  while read line; do
    case $i in
      0) location=$line;;
      1) updateIntervalSeconds=$line;;
      2) lastUpdate=$line;;
      3) lastWeather=$line;;
    esac

    i=$((i+1))
  done < $confFile
}

writeConfig() {
  echo -e "$location\n$updateIntervalSeconds\n$lastUpdate\n$lastWeather" \
    > $confFile
}


main() {
  loadConfig

  local currentTime=$(date +%s)
  local timeDiff=$(($currentTime - $lastUpdate))

  if [ $(($timeDiff)) -ge $(($updateIntervalSeconds)) ]; then
    lastWeather=$(curl -s "https://wttr.in/$location?format=4")
    lastUpdate=$currentTime
    writeConfig
  fi

  echo $lastWeather
}

echo $(main)
