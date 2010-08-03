helpers do
    
  def partial(page, options={})
    haml page, options.merge!(:layout => false)
  end

  def authenticated?; session[:user]; end
  
  def get_salt(login); Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--"); end
  
  def encrypt_password(salt, password); Digest::SHA1.hexdigest("--#{salt}--#{password}--"); end
  
  def create_user(login, password)
    salt = get_salt(login)
    password = encrypt_password(salt, password)
    User.create(:login => login, :salt => salt, :password => password, :created_at => Time.now)
  end
  
  def auth(login, password)
    user = User.first(:login => login)
    unless user
      unauth
      return false
    end
    session[:user] = user and return true if user.password == encrypt_password(user.salt, password)
  end
  
  def current_user; return session[:user]; end
  
  def unauth; session.delete(:user); end
  
  def get_forum(id); Forum.first(:id => id); end
  
  def get_topic(id); Topic.first(:id => id); end
  
  def sanitize(text)
    text.gsub(/</, "&lt;").gsub(/>/, "&gt;").gsub(/\n/, "<br />")
  end
  
end