require 'digest/sha1'

get '/login' do
  haml :login
end

post '/login' do
  redirect '/forums' if auth(params[:login], params[:password]) if params[:password] && params[:login]
  status 400 and return "Login failed"
end

get '/logout' do
  unauth and redirect '/login'
end

get '/users/new' do
  haml :new_user
end

post '/users' do
  unless params[:password] && params[:login] && (params[:password].blank? || params[:login].blank?)
    unless User.first(:login => params[:login])
      create_user(params[:login], params[:password])
      redirect '/login'
    else
      status 403 and return "User exists"
    end
  else
    status 400 and return "Please provide complete information"
  end
end















