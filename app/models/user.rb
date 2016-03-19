class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :omniauthable,:validatable,
         :omniauth_providers => [:facebook,:google_oauth2,:twitter]
  has_many :identities
  validates_presence_of :username

  def twitter
    identities.where( :provider => "twitter" ).first
  end

  def twitter_client
    @twitter_client ||= Twitter.client( access_token: twitter.accesstoken )
  end

  def facebook
    identities.where( :provider => "facebook" ).first
  end

  def facebook_client
    @facebook_client ||= Facebook.client( access_token: facebook.accesstoken )
  end

  def google_oauth2
    identities.where( :provider => "google_oauth2" ).first
  end

  def google_oauth2_client
    if !@google_oauth2_client
      @google_oauth2_client = Google::APIClient.new(:application_name => ' App', :application_version => "1.0.0" )
      @google_oauth2_client.authorization.update_token!({:access_token => google_oauth2.accesstoken, :refresh_token => google_oauth2.refreshtoken})
    end
    @google_oauth2_client
  end

  def self.from_omniauth(identity)
    user=self.new
    user.name = identity.name   # assuming the user model has a name
    user.username = identity.name.gsub(" ","")   # assuming the user model has a name
    user.email = identity.email || "#{user.username}-CHANGEME@example.com" 
    user.password = Devise.friendly_token[0,20]
    user.skip_confirmation!
    user.save(validate: false)
    return user
end
end
