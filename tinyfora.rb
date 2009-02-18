#!/usr/bin/env ruby
$:.unshift File.dirname(__FILE__)

require 'rubygems'
require 'sinatra'
require 'dm-core'

use Rack::ShowExceptions

configure do
  enable :sessions
  require 'models'
  DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/tinyfora.db")
  DataMapper::Logger.new(STDOUT, :debug)
  DataMapper.auto_migrate! unless File.exists?('tinyfora.db')
end

before do
  redirect '/login' unless authenticated? unless env['REQUEST_PATH'] =~ /^\/login|users|stylesheets|favicon/
end

get '/' do
  'Welcome to TinyFora'
end

get '/style.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :style
end

get %r{^/images/(.+)$} do
  content_type 'image/gif'
  open(File.join(Dir.pwd, "views", "images", params[:captures][0]), "r").read
end

%w(helpers.rb user_routes.rb forum_routes.rb topic_routes.rb post_routes.rb).each { |f| load f }


