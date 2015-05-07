#!/usr/bin/ruby

require_relative './src/tkeep-lib.rb'

def print_help
  puts "Welcome to the TimeKeeper CLI interface, version #{TKEEP_MAJ_VER}.#{TKEEP_MIN_VER}."
  puts
  puts "Usage: Enter a category to begin. This will start recording time for that category. " +
    "Entering a new category will save the current one to the database and immediately begin a new one."
  puts
  puts ".help will reprint this help screen."
  puts ".exit will exit the application, without saving."
  puts ".stop will end/save the current block and not begin a new one."
  puts ".clear will end the current block without saving it."
  puts
  puts "NOTE: You can save a note with the category by typing '; ' after the category."
  puts "For example: "
  puts "Category; this is a note."
  puts
end

# Immediately clear out all data and exit command mode.
def clear_block
  @current_command = false
  @command = nil
  @note = nil
  @start_time = nil
end

print_help
clear_block

while (true)
  print "Enter category: "
  command, note = gets.chomp.split('; ')
  command.capitalize!

  if command == ".stop"
    # If the user exits while currently recording a block, then save the block
    if @current_command
      Block.create(
        category: @command,
        note: @note,
        start_time: @start_time,
        end_time: Time.now
      )
    end

    command, note = nil, nil
    clear_block
    next
  end

  # Exit without saving current block
  if command == ".exit"
    exit
  end

  if command == ".help"
    print_help
    next
  end

  if command == ".clear"
    clear_block
    next
  end

  # If the user enteres a new category while and old one is active, then save the old gategory
  # and start a fresh one.
  if @current_command
    Block.create(
      category: @command,
      note: @note,
      start_time: @start_time,
      end_time: Time.now
    )

    @command = command
    @note = note
    @start_time = Time.now
    
    puts "New category: " + command if command[0] != '.'
  else
    @current_command = true
    @command = command
    @note = note
    @start_time = Time.now

    puts "New category: " + command if command[0] != '.'
  end
end

