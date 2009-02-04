class Forum
  include DataMapper::Resource

  property :id, Integer, :serial => true
  property :name, String, :key => true
  property :description, String
  property :created_at, DateTime
  
  has n, :topics
  
end

class Topic
  include DataMapper::Resource
  
  property :id, Integer, :serial => true
  property :title, String, :key => true
  property :created_at, DateTime
  
  belongs_to :forum, :class_name => 'Forum' # weird bug in DataMapper
  has n, :posts
  
end

class Post
  include DataMapper::Resource
  
  property :id, Serial
  property :body, Text
  property :created_at, DateTime
  
  belongs_to :topic
  belongs_to :user
  
end

class User
  include DataMapper::Resource
  
  property :id, Serial
  property :login, String, :key => true
  property :salt, String
  property :password, String
  property :created_at, DateTime
  
  has n, :posts
  
end

