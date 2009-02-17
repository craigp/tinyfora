# new
get %r{^/forums/(\d+)/topics/(\d+)/posts/new$} do
  @topic = get_topic(params[:captures][1])
  haml :new_post
end

# create
post '/forums/:forum_id/topics/:topic_id/posts' do
  @topic = get_topic(params[:topic_id])
  status 404 and return "Topic not found" unless @topic
  post = @topic.posts.create(:body => params[:body], :created_at => Time.now, :user => session[:user])
  redirect "/forums/#{@topic.forum.id}/topics/#{@topic.id}"
end
