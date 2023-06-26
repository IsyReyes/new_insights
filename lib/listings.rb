require "terminal-table"

class Listings
  def initialize(db)
    @db = db
  end

  def list_restaurants(category: nil, city: nil)
    query = "SELECT restaurant_name, category, city FROM Restaurants"
    params = []
    if category
      query += " WHERE LOWER(category) = LOWER($1)"
      params << category
    elsif city
      query += " WHERE LOWER(city) = LOWER($1)"
      params << city
    end
    result = @db.exec_params(query, params)

    table = Terminal::Table.new title: "List of Restaurants".colorize(:green).on_white.bold,
                                headings: ["Name", "Category", "City"] do |t|
      result.each do |row|
        t.add_row [row["restaurant_name"], row["category"], row["city"]]
      end
    end
    puts table
  end

  def list_dishes
    result = @db.exec("SELECT DISTINCT dish FROM Dishes ORDER BY dish")

    table = Terminal::Table.new title: "Unique Dishes Researched".colorize(:green).on_white.bold,
                                headings: ["Name"] do |t|
      result.each do |row|
        t.add_row [row["dish"]]
      end
    end
    puts table
  end

  def client_distribution(group: nil)
    query = <<~SQL
      SELECT #{group}, COUNT(*) as count,#{' '}
        ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Clients)), 2) as percentage
      FROM Clients
      GROUP BY #{group}
      ORDER BY count DESC
    SQL
    result = @db.exec(query)

    title = "Number and Distribution of Users grouped by #{group.capitalize}".colorize(:green).on_white.bold
    table = Terminal::Table.new title:, headings: [group.capitalize, "Users", "Percentage (%)"] do |t|
      result.each do |row|
        t.add_row [row[group], row["count"], row["percentage"]]
      end
    end
    puts table
  end

  def top_restaurants_by_visitors
    query = 'SELECT restaurant_name, COUNT(*) as visits
             FROM visits JOIN restaurants ON visits.restaurant_id = restaurants.id
             GROUP BY restaurant_name ORDER BY visits DESC LIMIT 10'
    result = @db.exec(query)

    table = Terminal::Table.new title: "Top 10 Restaurants by Number of Visitors".colorize(:green).on_white.bold,
                                headings: ["Name", "Number of Visitors"] do |t|
      result.each do |row|
        t.add_row [row["restaurant_name"], row["visits"]]
      end
    end
    puts table
  end

  def top_restaurants_by_sales
    query = 'SELECT restaurant_name, SUM(dish_price) as total_sales
             FROM visits
             JOIN restaurants ON visits.restaurant_id = restaurants.id
             JOIN prices ON visits.dish_id = prices.dish_id AND visits.restaurant_id = prices.restaurant_id
             GROUP BY restaurant_name
             ORDER BY total_sales DESC
             LIMIT 10'
    result = @db.exec(query)
  
    table = Terminal::Table.new title: "Top 10 Restaurants by Sales".colorize(:green).on_white.bold,
                                headings: ["Name", "Total Sales"] do |t|
      result.each do |row|
        t.add_row [row["restaurant_name"], row["total_sales"]]
      end
    end
    puts table
  end

  def top_restaurants_by_avg_expense
    query = 'SELECT restaurant_name, ROUND(CAST(AVG(total_expense) AS numeric), 1) as average_expense
             FROM (
               SELECT client_id, restaurant_name, SUM(dish_price) as total_expense
               FROM visits
               JOIN restaurants ON visits.restaurant_id = restaurants.id
               JOIN prices ON visits.dish_id = prices.dish_id AND visits.restaurant_id = prices.restaurant_id
               GROUP BY client_id, restaurant_name
             ) AS client_expenses
             GROUP BY restaurant_name
             ORDER BY average_expense DESC
             LIMIT 10'
    result = @db.exec(query)
  
    table = Terminal::Table.new title: "Top 10 Restaurants by Average Expense Per User".colorize(:green).on_white.bold,
                                headings: ["Name", "Average Expense"] do |t|
      result.each do |row|
        t.add_row [row["restaurant_name"], row["average_expense"]]
      end
    end
    puts table
  end

  def average_expense_by_group(group)
    query = %(
      SELECT #{group}, ROUND(CAST(AVG(prices.dish_price) AS numeric), 1) as average_expense
      FROM visits
      JOIN clients ON visits.client_id = clients.id
      JOIN prices ON visits.dish_id = prices.dish_id AND visits.restaurant_id = prices.restaurant_id
      GROUP BY #{group}
      ORDER BY average_expense DESC
    )
    result = @db.exec(query)
  
    table = Terminal::Table.new title: "Average Consumer Expense by #{group.capitalize}".colorize(:green).on_white.bold,
                                headings: [group.capitalize, "Average Expense"] do |t|
      result.each do |row|
        t.add_row [row[group], row["average_expense"]]
      end
    end
    puts table
  end

  def total_sales_by_month(order)
    query = %(
      SELECT TO_CHAR(visit_date, 'Month') as month, SUM(prices.dish_price) as total_sales
      FROM visits
      JOIN prices ON visits.dish_id = prices.dish_id AND visits.restaurant_id = prices.restaurant_id
      GROUP BY month
      ORDER BY total_sales #{order}
    )
    result = @db.exec(query)

    table = Terminal::Table.new title: "Total Sales by Month".colorize(:green).on_white.bold,
                                headings: ["Month", "Total Sales"] do |t|
      result.each do |row|
        t.add_row [row["month"], row["total_sales"]]
      end
    end
    puts table
  end

  def best_price_for_dish
    query = %(
      SELECT dish, restaurant_name, dish_price FROM (
        SELECT dishes.dish, restaurants.restaurant_name, prices.dish_price,
          ROW_NUMBER() OVER(PARTITION BY dishes.dish ORDER BY prices.dish_price ASC) as rn
        FROM dishes
        JOIN prices ON dishes.id = prices.dish_id
        JOIN restaurants ON prices.restaurant_id = restaurants.id
      ) AS ranked
      WHERE rn = 1
    )
    result = @db.exec(query)

    table = Terminal::Table.new title: "Best Price for Dish".colorize(:green).on_white.bold,
                                headings: ["Dish", "Restaurant", "Price"] do |t|
      result.each do |row|
        t.add_row [row["dish"], row["restaurant_name"], row["dish_price"]]
      end
    end
    puts table
  end

  def favorite_dish_by_filter(filter, value)
    case filter
    when "age"
      column = "clients.age"
      operator = "="
      table_title = "Favorite Dish by Age".colorize(:green).on_white.bold
    when "gender"
      column = "clients.gender"
      operator = "ILIKE"
      table_title = "Favorite Dish by Gender".colorize(:green).on_white.bold
    when "occupation"
      column = "clients.occupation"
      operator = "ILIKE"
      table_title = "Favorite Dish by Occupation".colorize(:green).on_white.bold
    when "nationality"
      column = "clients.nationality"
      operator = "ILIKE"
      table_title = "Favorite Dish by Nationality".colorize(:green).on_white.bold
    else
      return puts "Invalid filter. Please use age, gender, occupation, or nationality."
    end

    query = %(
      SELECT #{column} as group_column, dishes.dish, COUNT(*) as count
      FROM visits
      JOIN dishes ON visits.dish_id = dishes.id
      JOIN clients ON visits.client_id = clients.id
      WHERE #{column} #{operator} '#{value}'
      GROUP BY group_column, dishes.dish
      ORDER BY count DESC
      LIMIT 8
    )

    result = @db.exec(query)

    table = Terminal::Table.new title: table_title, headings: [filter.capitalize, "Dish", "Count"] do |t|
      result.each do |row|
        t.add_row [row["group_column"], row["dish"], row["count"]]
      end
    end
    puts table
  end
end
