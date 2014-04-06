Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, Push::Application.config.client_id, Push::Application.config.client_secret, :scope => 'gist,user:email,public_repo'
end