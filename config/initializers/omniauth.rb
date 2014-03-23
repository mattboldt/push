Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, Push::Application.config.client_id, Push::Application.config.client_secret, :scope => 'repo,gist,user,user:email,user:username'
end