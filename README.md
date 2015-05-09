# TimeKeeper v0.1

## Introduction

This is an application I created to allow me to track what time I was spending on things. It's based ona category system, where you switch between different blocks of time, categorized by name. For instance, you might switch into "Email" mode when checking emails, then "Lunch" when heading out for lunch. All of the information is stored in a SQLite3 DB under the folder ~/.tkeep/tkeep.db for easy queries and checking. There is some simple built-in reporting, to avoid having to query the SQLite db directly.

## Usage

As of this moment, there is a text-based interface, however a web-based interface is coming soon.

Execute the script `tkeep-lib.rb` and you will be presented with this prompt. Just follow this simple
help information:

```
Welcome to the TimeKeeper CLI interface, version 0.1.

Usage: Enter a category to begin. This will start recording time for that category. Entering a new category will save the current one to the database and immediately begin a new one.

.help will reprint this help screen.
.exit will exit the application, without saving.
.stop will end/save the current block and not begin a new one.
.clear will end the current block without saving it.
.report-all [start time] [end time]
    This will return the duration for all categories in the given timeframe. If no arguments
    are specified, then it uses all recorded times. If a start date is specified, the present
    is used for end time. Date parsing is flexible, but recommended format is YYYY-MM-DD.

NOTE: You can save a note with the category by typing '; ' after the category.
For example: 
Category; this is a note.
```

After this, it is simple to enter and exit modes to mark your time.

# Installation

Clone this git repository, and just add the folder to your path. Then you can execute `./tkeep-cli.rb`
to execute the application. Before executing, make sure to run `bundle install` from the application
folder to make sure all required gems are installed.
