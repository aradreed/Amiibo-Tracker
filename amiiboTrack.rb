#!/usr/bin/env ruby

# Amiibo Track v.5
# Arad Reed
# Tracks in stock alerts from nowinstock.net
# TODO: Allow audio to be played on both Windows and OSX

require 'mechanize'
require 'curses'

def read_item_file(filename) 
  # Reads a given file to see what to limit the alerts to
  # Stores items in an array
  items = []
  
  if File.exist? filename
    File.open(filename, "r") do |f|
      f.each_line do |item|
        items.push(item.chomp)
      end
    end
    
    return items
  else
    puts "Given file does not exist, running on all items"
  end
end

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
Curses.init_screen

# Given filename, track only items listed in file
tracked_items = read_item_file(ARGV[0]) if ARGV[0]

# Audio alert to play 
alert = './alert.wav'

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
    if (stock[0].include? "In Stock")
      
      if items
        if items.any? { |item| stock.include?(item) }
          pid = fork{ exec 'afplay', alert }
        end
      else
        pid = fork{ exec 'afplay', alert }
      end
    end
  end
  
  sleep(30)
  
end 