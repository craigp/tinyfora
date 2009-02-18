# show
get %r{^/forums/(\d+)/topics/(\d+)$} do
  @topic = get_topic(params[:captures][1])
  status 404 and return "Topic not found" unless @topic
  haml :topic
end

# new
get %r{^/forums/(\d+)/topics/new$} do
  @forum = get_forum(params[:captures][0])
  status 404 and return "Forum not found" unless @forum
  haml :new_topic
end

# create
post '/forums/:id/topics' do
  @forum = get_forum(params[:id])
  status 404 and return "Forum not found" unless @forum
  @topic = @forum.topics.create(:title => params[:title], :created_at => Time.now)
  @topic.posts.create(:body => params[:body], :created_at => Time.now, :user => current_user)
  redirect "/forums/#{@forum.id}/topics/#{@topic.id}"
end

