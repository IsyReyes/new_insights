dropdb insights
createdb insights
psql insights < ../sql/create.sql
ruby ../lib/insert_data.rb ../data/data.csv
ruby insights.rb