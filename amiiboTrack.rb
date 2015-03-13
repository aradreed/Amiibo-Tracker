#!/usr/bin/env ruby

# Amiibo Track v.3
# Arad Reed
# Tracks in stock alerts from nowinstock.net
# TODO: Allow audio to be played on both Windows and OSX

require 'mechanize'
require 'curses'

def get_stock(mech, link)
  # Grab the most recent stock data
  page = mech.get(link)
  
  data = '//div[@id="data"]/table//tr/td[2]'
  return page.search(data).to_s.gsub("<td>", "").split("</td>")
end

def get_times(mech, link)
  # Grab the corresponding times
  page = mech.get(link)
  
  data = '//div[@id="data"]/table//tr/td[1]'
  return page.search(data).to_s.gsub("<td>", "").split("</td>")
end

def output(stock_arr, times)
  Curses.clear
  
  # Add all stock to the screen
  stock_arr.each_with_index do |item, i|
    Curses.setpos(i, 0)
    Curses.addstr "#{item}\n"
    Curses.setpos(i, 50)
    Curses.addstr "#{times[i].strip}\n"
    
  end
  
  Curses.addstr "Scanning for data.."
  Curses.refresh
end

# Start Curses screen
#Curses.init_screen

# Audio alert to play 
file = './alert.wav'

# Tracking link
link = "http://www.nowinstock.net/modules/history/us/743.html"

mech = Mechanize.new
page = mech.get(link)
stock = get_stock(mech, link)

times = get_times(mech, link)
output(stock, times)

# Continously scrape the page for in stock data
while true
  if (get_stock(mech, link) != stock)
    # Set new stock
    stock = get_stock(mech, link)
    times = get_times(mech, link)
    
    output(stock, times)
    
    # Audio alert
    if (stock[0].include "In Stock")
      pid = fork{ exec 'afplay', file }
    end
  end
  
  sleep(30)
  
end 