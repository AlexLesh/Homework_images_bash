#!/bin/bash


for hour in {1..24}; do
  mkdir -p "image_${hour}h"
done

counter=1 

while true; do
  random_page=$((RANDOM % 999 + 2))
  
  cd "image_${counter}h"

  html_url="https://kartinkof.club/page/$random_page/"
  img_urls=($(curl -s "$html_url" | grep -oE 'src="([^"]+\.(jpg))' | sed 's/src="//'))
  for img_url in "${img_urls[@]}"; do
    curl -s -O "https://kartinkof.club$img_url"
  done

  sleep 10

  cd ..

  ((counter++))

  if [ "$counter" -gt 24 ]; then
    counter=1 

    echo "Checking for 24-hour interval..."

    find -type f ! -name "*.sh" ! -name "*.tar.gz" | tar -czf Image_archive_$(date "+%Y-%m-%d_%H-%M-%S").tar.gz -T -
    
    for hour in {1..24}; do
		rm -rf "image_${hour}h"
	done
	
	for hour in {1..24}; do
		mkdir -p "image_${hour}h"
	done

    echo "Archiving completed for the last 24 hours."
  fi
done
