# Insights
​
## Introduction
​
Welcome to Restaurants Insights, a powerful Command Line Application designed in Ruby. 
Our program leverages a robust and optimized PostgreSQL relational database to provide valuable insights drawn from complex restaurant data. 
It is aimed at satisfying the users' need of insights by answering their deep-seated questions.
​
## Features
​
- Automated database updates: always work with the latest data.
- Flexibility: users can input their preferred CSV file directly via the command line.
- Efficient data organization: leverages the power of SQL queries to efficiently organize, 
  manage and extract insights from the provided data.
- Variety of display options: users can choose how they want their lists organized.
- Shows the lists in clean and easy to read terminal tables.
- User-friendly output: data is presented in easy-to-read, colorful terminal tables for an enhanced user experience.

## Technologies
​
- Ruby (version 3.1.2p20 or higher): for the application logic and user interface.
- PostgreSQL (version 14.8 or higher): for robust and efficient data management.

## Installation and Usage
​
1. Ensure that you have Ruby (version 3.1.2p20 or higher) and PostgreSQL (version 14.8 or higher) installed on your system.
2. Create a PostgreSQL database named `insights`. You can do this with the command: `createdb insights` in your terminal.
3. Clone this repository to your local machine.
4. Navigate to the directory of the cloned repository via the terminal.
5. Run `bundle install` to install required RubyGems.
6. Start the app by running `bash db_reset.sh`. If you want to input a different CSV file, modify line 4 in the `db_reset.sh` file (replace "../data/data.csv" with your preferred file).
7. Follow the prompts to select your desired option from the menu, along with any additional filters or fields.
​
## Contribution
​
We welcome contributions to Restaurants Insights! If you have ideas for improvements or bug fixes, feel free to open a pull request.
​
## License
​
This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE.txt) file for details.
