Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, 'c39633bffd86eff124e3', 'e9fc594d4067a983645d961e99a1f489239d37bb', :scope => 'repo,gist'
end