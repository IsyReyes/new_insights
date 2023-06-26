require "pg"
require "csv"

csv_file = ARGV[0]

class Insert
  def initialize(csv_file)
    @csv_file = csv_file
  end

  def insert_data(database_name)
    db = PG.connect(dbname: database_name)
  
    CSV.foreach(@csv_file, headers: true) do |row|
      client_id = find_or_create_client(db, row)
      restaurant_id = find_or_create_restaurant(db, row)
      dish_id = find_or_create_dish(db, row)
      find_or_create_price(db, row, dish_id, restaurant_id)
      create_visit(db, row, client_id, restaurant_id, dish_id)
    end
  end

  def find_or_create_client(db, row)
    result = db.exec_params(
      "SELECT id FROM clients WHERE client_name = $1 AND age = $2 AND gender = $3 AND occupation = $4 AND nationality = $5",
      [row["client_name"], row["age"].to_i, row["gender"], row["occupation"], row["nationality"]]
    )
    return result[0]["id"] if result.any?

    result = db.exec_params(
      "INSERT INTO clients (client_name, age, gender, occupation, nationality) VALUES ($1, $2, $3, $4, $5) RETURNING id",
      [row["client_name"], row["age"], row["gender"], row["occupation"], row["nationality"]]
    )
    result[0]["id"]
  end

  def find_or_create_restaurant(db, row)
    result = db.exec_params(
      "SELECT id FROM restaurants WHERE restaurant_name = $1 AND category = $2 AND city = $3 AND address = $4",
      [row["restaurant_name"], row["category"], row["city"], row["address"]]
    )
    return result[0]["id"] if result.any?

    result = db.exec_params(
      "INSERT INTO restaurants (restaurant_name, category, city, address) VALUES ($1, $2, $3, $4) RETURNING id",
      [row["restaurant_name"], row["category"], row["city"], row["address"]]
    )
    result[0]["id"]
  end

  def find_or_create_dish(db, row)
    result = db.exec_params(
      "SELECT id FROM dishes WHERE dish = $1",
      [row["dish"]]
    )
    return result[0]["id"] if result.any?
  
    result = db.exec_params(
      "INSERT INTO dishes (dish) VALUES ($1) RETURNING id",
      [row["dish"]]
    )
    result[0]["id"]
  end

  def find_or_create_price(db, row, dish_id, restaurant_id)
    result = db.exec_params(
      "SELECT id FROM prices WHERE dish_id = $1 AND restaurant_id = $2",
      [dish_id, restaurant_id]
    )
    return result[0]["id"] if result.any?
  
    result = db.exec_params(
      "INSERT INTO prices (dish_id, restaurant_id, dish_price) VALUES ($1, $2, $3) RETURNING id",
      [dish_id, restaurant_id, row["price"]]
    )
    result[0]["id"]
  end

  def create_visit(db, row, client_id, restaurant_id, dish_id)
    db.exec_params(
      "INSERT INTO visits (visit_date, client_id, restaurant_id, dish_id) VALUES ($1, $2, $3, $4)",
      [row["visit_date"], client_id, restaurant_id, dish_id]
    )
  end
end

insert = Insert.new(csv_file)
insert.insert_data("insights")
