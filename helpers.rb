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
  
  # stolen from rails
  def time_ago_in_words(from_time, to_time = Time.now, include_seconds = false)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round

    case distance_in_minutes
      when 0..1
        return (distance_in_minutes == 0) ? 'less than a minute' : '1 minute' unless include_seconds
        case distance_in_seconds
          when 0..4   then 'less than 5 seconds'
          when 5..9   then 'less than 10 seconds'
          when 10..19 then 'less than 20 seconds'
          when 20..39 then 'half a minute'
          when 40..59 then 'less than a minute'
          else             '1 minute'
        end

      when 2..44           then "#{distance_in_minutes} minutes"
      when 45..89          then 'about 1 hour'
      when 90..1439        then "about #{(distance_in_minutes.to_f / 60.0).round} hours"
      when 1440..2879      then '1 day'
      when 2880..43199     then "#{(distance_in_minutes / 1440).round} days"
      when 43200..86399    then 'about 1 month'
      when 86400..525599   then "#{(distance_in_minutes / 43200).round} months"
      when 525600..1051199 then 'about 1 year'
      else                      "over #{(distance_in_minutes / 525600).round} years"
    end
  end

end