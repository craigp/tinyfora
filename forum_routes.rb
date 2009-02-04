# index
get '/forums' do
  @forums = Forum.all
  haml :forums
end

# show
get %r{^/forums/(\d+)$} do
  @forum = Forum.first(:id => params[:captures][0])
  status 404 and return "Forum not found" unless @forum
  haml :forum
end

# new
get '/forums/new' do
  haml :new_forum
end

# create
post '/forums' do
  Forum.create(:name => params[:name], :description => params[:description], :created_at => Time.now)
  redirect "/forums"
end

