CREATE TABLE Clients (
    id SERIAL PRIMARY KEY,
    client_name VARCHAR(25),
    age INTEGER,
    gender VARCHAR(25),
    occupation VARCHAR(25),
    nationality VARCHAR(25)
);

CREATE TABLE Restaurants (
    id SERIAL PRIMARY KEY,
    restaurant_name VARCHAR(25),
    category VARCHAR(25),
    city VARCHAR(25),
    address VARCHAR(25)
);

CREATE TABLE Dishes (
    id SERIAL PRIMARY KEY,
    dish VARCHAR(50)
);

CREATE TABLE Visits (
    id SERIAL PRIMARY KEY,
    visit_date DATE,
    client_id INTEGER REFERENCES Clients(id),
    restaurant_id INTEGER REFERENCES Restaurants(id),
    dish_id INTEGER REFERENCES Dishes(id)
);

CREATE TABLE Prices (
    id SERIAL PRIMARY KEY,
    dish_price INTEGER,
    restaurant_id INTEGER REFERENCES Restaurants(id),
    dish_id INTEGER REFERENCES Dishes(id)
);