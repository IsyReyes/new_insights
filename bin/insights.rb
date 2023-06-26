require "pg"
require "colorize"
require_relative "../lib/listings"
require_relative "../lib/print_helpers"

db = PG.connect(dbname: "insights")

listings = Listings.new(db)

def run_program(listings)
  print_welcome
  print_menu
  loop do
    puts "Pick a number from the list and an [option] if necessary".colorize(:blue)
    print "> "
    choice = gets.chomp

    if choice.downcase == "quit"
      # puts "Thank you for using the Restaurants Insights. Goodbye!".colorize(:blue).on_green
      print_thank_you
      break
    elsif choice.downcase == "menu"
      print_menu
      next
    end

    parts = choice.split
    command = parts[0].to_i
    options = parts[1..].join(" ") if parts.size > 1

    case command
    when 1
      if options
        key, value = options.split("=")
        case key
        when "category"
          listings.list_restaurants(category: value.strip)
        when "city"
          listings.list_restaurants(city: value.strip)
        else
          puts "Invalid filter. Please enter 'category' or 'city'."
        end
      else
        listings.list_restaurants
      end
    when 2
      listings.list_dishes
    when 3
      if options
        key, value = options.split("=")
        case key
        when "group"
          listings.client_distribution(group: value.strip)
        else
          puts "Invalid filter. Please enter 'group' with either 'age', 'gender', 'occupation', or 'nationality'."
        end
      else
        puts "Missing 'group' parameter. Please enter 'group' with either 'age', 'gender', 'occupation', or 'nationality'."
      end
    when 4
      listings.top_restaurants_by_visitors
    when 5
      listings.top_restaurants_by_sales
    when 6
      listings.top_restaurants_by_avg_expense
    when 7
      if options
        _, value = options.split("=")
        case value
        when "age", "gender", "occupation", "nationality"
          listings.average_expense_by_group(value.strip)
        else
          puts "Invalid group. Please enter 'age', 'gender', 'occupation', or 'nationality'."
        end
      else
        puts "Invalid option. Please enter a group by 'age', 'gender', 'occupation', or 'nationality'."
      end
    when 8
      if options
        _, value = options.split("=")
        case value
        when "asc", "desc"
          listings.total_sales_by_month(value.strip)
        else
          puts "Invalid order. Please enter 'asc' or 'desc'."
        end
      else
        puts "Invalid option. Please enter an order by 'asc' or 'desc'."
      end
    when 9
      listings.best_price_for_dish
    when 10
      if options
        filter, value = options.split("=")
        if value
          listings.favorite_dish_by_filter(filter, value.strip)
        else
          puts "Missing value for #{filter}. Please specify a value for 'age', 'gender', 'occupation', or 'nationality'."
        end
      else
        puts "Missing filter. Please specify 'age', 'gender', 'occupation', or 'nationality'."
      end
    else
      puts "Invalid option. Please enter a number from 1 to 10 or type 'menu' to see the options again or 'quit' to exit."
    end
  end
end

run_program(listings)
#ilovegithub