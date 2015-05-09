#!/usr/bin/ruby

require 'date'

require_relative './src/tkeep-lib.rb'
require_relative './src/float.rb'

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
  puts ".report-all [start time] [end time]"
  puts "    This will return the duration for all categories in the given timeframe. If no arguments"
  puts "    are specified, then it uses all recorded times. If a start date is specified, the present"
  puts "    is used for end time. Date parsing is flexible, but recommended format is YYYY-MM-DD."
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
        end_time: Time.now,
        duration: Time.now - @start_time
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

  # Display help
  if command == ".help"
    print_help
    next
  end

  # Clear current block without saving
  if command == ".clear"
    clear_block
    next
  end

  report_cmd = command.split
  if report_cmd[0] == ".report-all"
    # If there is no arguments, select all
    if report_cmd.size == 1
      blocks = Block.all
    # If there is one argument, use it as starting time
    elsif report_cmd.size == 2
      st = (Date.parse report_cmd[1]).to_time
      et = Time.now
      blocks = Block.all(:start_time.gte => st, :end_time.lte => et)
    # Otherwise, use a specified start and end time, i.e.: .report-all 2015-01-01 2015-03-01
    else
      st = (Date.parse report_cmd[1]).to_time
      et = (Date.parse report_cmd[2]).to_time
      blocks = Block.all(:start_time.gte => st, :end_time.lte => et)
    end

    # Tally up the total duration into a hash
    all_reports = Hash.new(0)
    blocks.each do |b|
      all_reports[b.category] += b.duration
    end

    # Display the actual duration
    puts "Total Duration (by category)"
    all_reports.each do |k,v|
      puts "#{k} => #{v.to_duration}"
    end
    puts
    next
  end

  # If the user enteres a new category while and old one is active, then save the old gategory
  # and start a fresh one.
  if @current_command
    Block.create(
      category: @command,
      note: @note,
      start_time: @start_time,
      end_time: Time.now,
      duration: Time.now - @start_time
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

