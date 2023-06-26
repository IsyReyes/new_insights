def print_welcome
  text = "Welcome to Restaurants Insights!".colorize(:cyan).on_green.bold
  delay = 0.076

  text.chars.each do |char|
    print char
    sleep(delay)
  end
  puts
end

def print_thank_you
  text = "Thank you for using Restaurants Insights. Goodbye!".colorize(:cyan).on_green.bold
  delay = 0.066

  text.chars.each do |char|
    print char
    sleep(delay)
  end
  puts
end

def print_menu
  puts "---".colorize(:cyan)
  text = [
    "Write 'menu' at any moment to print the menu again and 'quit' to exit.".colorize(:light_blue),
    "Please select an option from the menu below:".colorize(:cyan),
    "1.".blue + " List of restaurants included in the research filter by ['' | category=string | city=string]".colorize(:green),
    "2.".blue + " List of unique dishes included in the research".colorize(:green),
    "3.".blue + " Number and distribution (%) of clients by [group=[age | gender | occupation | nationality]]".colorize(:green),
    "4.".blue + " Top 10 restaurants by the number of visitors".colorize(:green),
    "5.".blue + " Top 10 restaurants by the sum of sales".colorize(:green),
    "6.".blue + " Top 10 restaurants by the average expense of their clients".colorize(:green),
    "7.".blue + " The average consumer expense group by [group=[age | gender | occupation | nationality]]".colorize(:green),
    "8.".blue + " The total sales of all the restaurants group by month [order=[asc | desc]]".colorize(:green),
    "9.".blue + " The list of dishes and the restaurant where you can find it at a lower price".colorize(:green),
    "10.".blue + " The favorite dish for [age=number | gender=string | occupation=string | nationality=string]".colorize(:green)
  ]
  delay = 0.2

  text.each do |line|
    puts line
    sleep(delay)
  end

  puts "---".colorize(:cyan)
end
