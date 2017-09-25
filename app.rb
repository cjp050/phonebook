require "sinatra"
require_relative "phonebook.rb"
require 'pg'
require "bcrypt"
enable 'sessions'
load './local_env.rb' if File.exist?('./local_env.rb')

db_params = {
    host: ENV['host'],
    port: ENV['port'],
    dbname: ENV['db_name'],
    user: ENV['user'],
    password: ENV['password']
}

$db = PG::Connection.new(db_params)

get '/' do 
   login = $db.exec("Select * from login")
    # phonebook = $db.exec("Select * From data")
    erb :login, locals: {login: login}
end 

post "/login" do 
    username = params[:username]
    password = params[:password]

    correct = $db.exec("SELECT * FROM login WHERE username = '#{username}'")
    login_data = correct.values.flatten
    if login_data.include?(password)
    redirect "/index"
    else 
        redirect "/"
    end
    
end

post "/register" do
    user = params[:new_user]
    password = params[:new_password]
    $db.exec("INSERT INTO login(username, password) VALUES('#{user}', '#{password}')");
redirect "/"
end
 
get "/index" do 
    info = $db.exec("Select * From login")
    #info_array = info.values
    erb :index, locals: {info: info}
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
    $db.exec("INSERT INTO public.data(first_name, last_name, address, phonenumber, email, city, state, zip) VALUES('#{first_name}', '#{last_name}', '#{address}', '#{phonenumber}', '#{email}', '#{city}', '#{state}', '#{zip}')");
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

post "/delete" do
    deleted = params[:data_to_delete]
    column = params[:table_column]
case column
       when 'col_first_name'
        db.exec("DELETE FROM data WHERE first_name = '#{deleted}'")
    when 'col_last_name'
           db.exec("DELETE FROM data WHERE last_name = '#{deleted}'");
       when 'col_address'
        db.exec("DELETE FROM data WHERE address = '#{deleted}'");
    when 'col_city'
        db.exec("DELETE FROM data WHERE city = '#{deleted}'");
    when 'col_state'
        db.exec("DELETE FROM data WHERE state = '#{deleted}'");
    when 'col_zip'
        db.exec("DELETE FROM data WHERE zip = '#{deleted}'");        
    when 'col_phone'
        db.exec("DELETE FROM data WHERE phone = '#{deleted}'");
    when 'col_email'
     db.exec("DELETE FROM data WHERE email = '#{deleted}'");
end
 redirect '/'
end

post '/delete_all' do 
    db.exec("TRUNCATE data");
    redirect '/'
end 

get '/search_contacts' do 
    erb :search_contacts
end 

post '/handle_search' do 
    @params = params
    print @params
    session[:search_table] = full_search_table_render(@params)
    print session[:search_table]
    redirect '/search_contacts' 
end 