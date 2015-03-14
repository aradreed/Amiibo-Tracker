# Amiibo-Tracker v.7

## Description
This script scrapes http://www.nowinstock.net/videogaming/games/amiibo/ for an amiibo alert. The site is scraped every 30 seconds by default and shows the current tracker history. It will play the alert sound when the newest thing added on the tracker history is in stock.

## Requirements
This script needs Ruby installed to run. It also uses the mechanize and curses gems, but those will be installed if not already. 

## Usage
Simply start the script with 

````
./amiiboTrack.rb
````

If you would like to get alerts for only certain ones, put them in a txt file (one line per item) and pass that to the program. See the included items.txt for examples.

````
./amiiboTrack.rb ./items.txt
````

...and then wait for amiibo to come.