module ApplicationHelper
  def avatar_url(user)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png"
  end
  def resource_name
    :user
  end

  def user_post_compliment
    compliments = [
      "wonderful",
      "magnificent",
      "out of this world",
      "genuis",
      "very talented",
      "prolific"
    ]
    "the " + compliments[rand(0..5)].to_s
  end

  def post_timestamp(date)
    date = Time.new
    date.strftime("%A #{date.day.ordinalize}, %Y")
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
