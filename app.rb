require "sinatra"
require 'pg'
load './local_env.rb' if File.exist?('./local_env.rb')

db_params = {
    host: ENV['host'],
    port: ENV['port'],
    dbname: ENV['db_name'],
    user: ENV['user'],
    password: ENV['password']
}

db = PG::Connection.new(db_params)

get '/' do 
    phonebook = db.exec("Select * From data")
    erb :index, locals: {phonebook: phonebook}
    
end 

post '/index' do 
    first_name = params[:first_name]
    last_name = params[:last_name]
     address = params[:address]
    email = params[:email]
    state = params[:state]
    city = params[:city]
    zip = params[:zip]
    phonenumber = params[:phonenumber]
    db.exec("INSERT INTO public.data(first_name, last_name, address, phonenumber, email, city, state, zip) VALUES('#{first_name}', '#{last_name}', '#{address}', '#{phonenumber}', '#{email}', '#{city}', '#{state}', '#{zip}')");
end 