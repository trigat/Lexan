# Lexan - GPG Encryption Manager
# Copyright (C) 2017, Josh M <mcu@protonmail.com>                     

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
$LOAD_PATH << '.'
require 'curses'
include Curses
require 'gpgopt'

Curses.init_screen
Curses.curs_set(0)  # Invisible cursor
Curses.start_color

# Change the colors of your menu here.
Curses.init_pair(1, Curses::COLOR_WHITE, Curses::COLOR_MAGENTA)  # RED, MAGENTA, GREEN, BLUE, etc
Curses.init_pair(2, Curses::COLOR_WHITE, Curses::COLOR_GREEN)
Curses.init_pair(3, Curses::COLOR_GREEN, Curses::COLOR_BLACK)  # nav words color

Curses.noecho # echo or noecho to display user input
Curses.cbreak # do not buffer commands until Enter is pressed
Curses.raw # disable interpretation of keyboard input
Curses.nonl
Curses.stdscr.nodelay = 1

# Top Header
SCREEN_WIDTH       = 72
HEADER_HEIGHT      = 1
HEADER_WIDTH       = SCREEN_WIDTH

# Left Header
SCREEN_WIDTHLEFT      = 47
HEADER_HEIGHTLEFT     = 1
HEADER_WIDTHLEFT      = SCREEN_WIDTHLEFT

# Right Header
SCREEN_WIDTHRIGHT       = 20
HEADER_HEIGHTRIGHT      = 1
HEADER_WIDTHRIGHT       = SCREEN_WIDTHRIGHT

# MAIN MENU OPTION FUNCTIONS

class GPGoptions
include Option

  def Option.fstart           # function start
    Curses.close_screen
    system "clear" or system "cls"
  end
  
  def Option.fend             # function end
    if $?.exitstatus > 0
      puts "You do not have GPG installed." 
    end
    puts "\n\nPress Enter to continue."
    gets # waits for the user to press enter
  end
  
  def Option.fend2            # 2nd function end
    if $?.exitstatus > 0
      puts "\nThere was an error." 
    end
    puts "Press Enter to continue."
    gets # waits for the user to press enter
  end

end

begin
  
	# Title Bar
	header_window = Curses::Window.new(HEADER_HEIGHT, HEADER_WIDTH, 0, 0)   # (height, width, top, left)
	header_window.color_set(1)
	header_window << "Lexan   ::   Encryption Manager".center(HEADER_WIDTH)
	header_window.refresh
	
	header2_window = Curses::Window.new(HEADER_HEIGHTLEFT, HEADER_WIDTHLEFT, 2, 2)
	header2_window.color_set(2)
	header2_window << "Main Menu".center(HEADER_WIDTHLEFT)
	header2_window.refresh
	
	header3_window = Curses::Window.new(HEADER_HEIGHTRIGHT, HEADER_WIDTHRIGHT, 2, 50)
	header3_window.color_set(2)
	header3_window << "Navigation".center(HEADER_WIDTHRIGHT)
	header3_window.refresh
	
	
	# right side navigation menu
	nav = Window.new(20, 20, 3, 50)  # (height, width, top, left)
	nav.attrset(Curses.color_pair(3) | Curses::A_BOLD)
	# nav.box('|', '-')
	nav.setpos(1, 2)
	nav.addstr "Select (Enter)"
	nav.setpos(2, 2)
	nav.addstr "Up     (W)"
	nav.setpos(3, 2)
	nav.addstr "Down   (S)"
	nav.setpos(4, 2)
	nav.addstr "Exit   (X)"
	nav.refresh

	# static text for main window
	def make_menu(menu, menu_index=nil)
    l = ["Get started with new key.", "List keys.", "Import and export keys.", "Delete keys.", "Fingerprint and sign key.",\
      "Trust a key.", "Quick encrypt.", "Encrypt with name.", "Quick decrypt.", "Decrypt with name.", "Terminal decrypt.",\
      "Encrypt file for e-mail and web.", "Create or verify signature file.", "Generate a revocation key."]
	  l.each_with_index do |element, index|
	    menu.setpos(index + 1, 1)
	    menu.attrset(index == menu_index ? A_STANDOUT : A_NORMAL) # standout creates highlight
      j = "#{index}."  
		  menu.addstr(j.ljust(4) + element)   # left justify
	  end
	  menu.setpos(5, 1)
	end
	
	# refresh text for main menu
	def make_info(menu, text)
	  menu.setpos(16, 30)  # sets the position of move up and down
	                     # for example, menu.setpos(1, 10) moves to another
	                     # location
	  menu.attrset(A_NORMAL)
	  menu.addstr text
	end
	
	
	# user navigation for main window
	position = 0

	menu = Window.new(20, 47, 3, 2)  # (height, width, top, left)
	menu.keypad = true  # enable keypad which allows arrow keys
	# menu.box('|', '-')
	make_menu(menu, position)
	while ch = menu.getch
	  stdscr.keypad = true
	  case ch
	  when KEY_UP, 'w'
	    #make_info menu, 'move up'
	    position -= 1
	  when KEY_DOWN, 's'
	    #make_info menu, 'move down'
	    position += 1
	  when 13 # 13 equals enter key
	    if position.zero?
		    Option.placezero # function goes here
	    elsif position == 1
		    Option.placeone
		  elsif position == 2
		    Option.placetwo
      elsif position == 3
        Option.placethree
      elsif position == 4
        Option.placefour
      elsif position == 5
        Option.placefive
      elsif position == 6
        Option.placesix
      elsif position == 7
        Option.placeseven
      elsif position == 8
        Option.placeeight
      elsif position == 9
        Option.placenine
      elsif position == 10
        Option.placeten
      elsif position == 11
        Option.placeeleven
      elsif position == 12
        Option.placetwelve
      elsif position == 13
        Option.placethirteen
	    else
		  Curses.close_screen
		  system "clear" or system "cls"
		  puts "Test 2."
		  puts "\n\nPress Enter to continue."
		  gets # waits for the user to press enter
	    end
	  when 'x'
	    exit
	  end
	  position = 13 if position < 0
	  position = 0 if position > 13
	  make_menu(menu, position)
	  make_info menu, "Select Option #{position} "  # keep space here so that it formats properly  
	end

rescue => ex
  Curses.close_screen
end
