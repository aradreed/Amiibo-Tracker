# Amiibo-Tracker v.3

## Description
First, I believe this script only works on a Mac for the moment only due to the audio line. Without audio, it should work on either. 

This script scrapes http://www.nowinstock.net/videogaming/games/amiibo/ for an amiibo alert. The site is scraped every 30 seconds by default and shows the current tracker history. It will play the alert sound when the newest thing added on the tracker history is in stock.

## Requirements
This script requires the 'mechanize' and 'curses' gems

## Usage
Simply start the script with 

````
./amiiboTrack.rb
````

...and then wait for amiibo to come.