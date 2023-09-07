Rails.application.config.middleware.use OmniAuth::Builder do
	if Rails.env.development? || Rails.env.test?
		provider :github, "c15ad325c2ea4c1bf560", "a8e61b45296bb0e60611ec3932e4bfbba5950ae4"
	else
		provider :github,
			Rails.application.credentials.github[:client_id]
			Rails.application.credentials.github[:client_secret]
	end
end
