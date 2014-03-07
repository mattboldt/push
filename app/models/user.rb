# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  username               :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  git_username           :string(255)
#

class User < ActiveRecord::Base
  has_many :authentications
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts

  def to_param
    username
  end
  # custom_slugs_with(:username)

  def apply_omniauth(omniauth)
    self.email = omniauth['info']['email'] if email.blank?
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
