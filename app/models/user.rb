class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  def screen_name
    email.split('@').first
  end
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email # facebook will not provide email as default now, had to set info_fields on config.
      user.name = auth.info.name
      user.image = auth.info.image
      puts "\n\n#{auth}\n\n"
      puts "user email is #{user.email}"
      user.password = Devise.friendly_token[0,20]
      user.uid = auth.uid
      #user.name = auth.info.name   # assuming the user model has a name
      #user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank? 
      end
    end
  end

  # param user_ids - An array of user IDs
  # Return a list of emails that are associated with the given list of user IDs
  def self.find_emails(user_ids)
    emails = Array.new

    user_ids.each do |id|
      user = User.find(id.to_s)
      emails << user[:email]
    end

    emails
  end

end
