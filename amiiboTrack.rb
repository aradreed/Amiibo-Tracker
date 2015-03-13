#!/usr/bin/env ruby

# Amiibo Track v.2
# Arad Reed
# Tracks in stock alerts from nowinstock.net

require 'mechanize'
require 'curses'

def get_stock(mech, link)
  # Grab the most recent data
  page = mech.get(link)
  
  data = '//div[@id="data"]/table//tr/td[2]'
  return page.search(data).to_s.gsub("<td>", "").split("</td>")
end

def output(stock_arr)
  Curses.clear
  Curses.setpos(0, 0)
  
  # Add all stock to the screen
  stock_arr.each {|item| Curses.addstr "#{item}\n"}
  Curses.addstr "Scanning for data.."
  Curses.refresh
end

# Start Curses screen
Curses.init_screen

# Audio alert to play 
file = './alert.wav'

# Tracking link
link = "http://www.nowinstock.net/modules/history/us/743.html"

mech = Mechanize.new
page = mech.get(link)
stock = get_stock(mech, link)

output(stock)

# Continously scrape the page for in stock data
while true
  if (get_stock(mech, link) != stock)
    # Set new stock
    stock = get_stock(mech, link)
    
    # Audio alert
    if (stock[0].include "In Stock")
      pid = fork{ exec 'afplay', file }
      output(stock)
    end
  end
  
  sleep(30)
  
end 