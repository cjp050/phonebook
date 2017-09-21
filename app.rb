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
    redirect '/'
end 

post '/column_refresh' do 
    new_data = params[:new_data]
    old_data = params[:old_data]
    column = params[:table]

    case column
when 'col_first_name'
    db.exec("UPDATE data SET first_name = '#{new_data}' WHERE first_name = '#{old_data}' ");
when 'col_last_name' 
    db.exec("UPDATE data SET first_name = '#{new_data}' WHERE last_name = '#{old_data}' ");
when 'col_address'
    db.exec("UPDATE data SET first_name = '#{new_data}' WHERE address = '#{old_data}' ");
when 'col_email'
    db.exec("UPDATE data SET first_name = '#{new_data}' WHERE email = '#{old_data}' ");
when 'col_state'
    db.exec("UPDATE data SET first_name = '#{new_data}' WHERE state = '#{old_data}' "); 
when 'col_city'
    db.exec("UPDATE data SET first_name = '#{new_data}' WHERE city = '#{old_data}' ");
when 'col_zip'
    db.exec("UPDATE data SET first_name = '#{new_data}' WHERE zip = '#{old_data}' ");
when 'col_phonenumber'
    db.exec("UPDATE data SET first_name = '#{new_data}' WHERE phonenumber = '#{old_data}' ");
    end 
    redirect '/'
end 

post '/delete_all' do 
    db.exec("TRUNCATE data");
    redirect '/'
end 