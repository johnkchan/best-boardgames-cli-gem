require './lib/boardgame.rb'
require './lib/scraper.rb'
require 'nokogiri'
require 'colorize'

class CommandLineInterface

  def run
    make_boardgames
    add_attributes_to_boardgames
    call
  end

  def make_boardgames
    boardgame_array = Scraper.scrape_top_50
    Boardgame.create_from_collection(boardgame_array)
  end

  def add_attributes_to_boardgames
    Boardgame.all.each do |boardgame|
      attributes = Scraper.scrape_boardgame_attributes(boardgame.url)
      boardgame.add_boardgame_attributes(attributes)
    end
  end

  def display_info(boardgame)
    puts "#{boardgame.name.upcase}".colorize(:red)
    puts "  ID:".colorize(:blue) + " #{boardgame.id}"
    puts "  URL:".colorize(:blue) + " #{boardgame.url}"
    puts "  Description:".colorize(:blue) + " #{boardgame.description}"
    puts "  Price:".colorize(:blue) + " #{boardgame.price}"
    puts "  Ages:".colorize(:blue) + " #{boardgame.ages}"
    puts "  Players:".colorize(:blue) + " #{boardgame.players}"
    puts "  Play Time:".colorize(:blue) + " #{boardgame.play_time}"
    puts "  Mechanics:".colorize(:blue) + " #{boardgame.mechanics}"
    puts "--------------------------------------------------------------------------------".colorize(:green)
  end

  # Lists Top 50 Boardgames
  def display_all
    puts "--------------------------------------------------------------------------------".colorize(:green)
    puts "Top 50 Boardgames".colorize(:red)
    puts "--------------------------------------------------------------------------------".colorize(:green)
    Boardgame.all.each do |boardgame|
      puts "Id:".colorize(:blue) + " #{boardgame.id}\t" + "Name:".colorize(:blue) + " #{boardgame.name}"
    end
    puts "--------------------------------------------------------------------------------".colorize(:green)
  end

  # Display Details for Specific Boardgames
  def display_details_by_id
    input_id = ""
    print "Please enter Boardgame Id: "
    input_id = gets.strip.to_i

    # Validate User Input
    while input_id < 1 || input_id > 50
      puts "I was unable to find any information for this Boardgame Id."
      print "Please enter new Boardgame Id: "
      input_id = gets.strip.to_i
    end

    boardgame = Boardgame.all.find_all{ |boardgame| boardgame.id == input_id }.first
    display_info(boardgame)
  end

  # Display Details for All Boardgames
  def display_all_details
    Boardgame.all.each do |boardgame|
      display_info(boardgame)
    end
  end

  def call
    puts "Welcome to the Top 50 Boardgame Catalog!".colorize(:red)
    puts "--------------------------------------------------------------------------------".colorize(:green)
    input = ""
    while input != "exit"
      puts "Commands".colorize(:red)
      puts "--------------------------------------------------------------------------------".colorize(:green)
      puts "To see top 50 boardgames listing, enter 'list all'.".colorize(:yellow)
      puts "To see top 50 boardgames details, enter 'show all details'.".colorize(:yellow)
      puts "To see specific boardgame details, enter 'show bg details'.".colorize(:yellow)
      puts "To quit, type 'exit'.".colorize(:yellow)
      print "What would you like to do? "

      input = gets.strip
      case input
        when "list all"
          display_all
        when "show all details"
          display_all_details
        when "show bg details"
          display_details_by_id
        when "exit"
        else
          puts "I did not recognize that command, please try again"
      end
    end
  end

end