class User < ActiveRecord::Base
  has_many :authentications
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable
  has_many :posts

  def apply_omniauth(omniauth)
    authentications.build(
        :username => omniauth['info']['nickname'],
        :provider => omniauth['provider'],
        :uid => omniauth['uid'],
        :token => omniauth['credentials']['token']
      )
  end
  # def self.from_omniauth(auth)
  #   find_by_provider_and_uid(auth["provider"], auth["uid"]) || create_with_omniauth(auth)
  # end

  # def self.create_from_omniauth(omniauth)
  #   User.new.tap do |user|
  #     user.github_uid = omniauth["uid"]
  #     user.name = omniauth["info"]["nickname"]
  #     user.email = omniauth["info"]["email"]
  #     user.save!
  #   end
  # end
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
end
