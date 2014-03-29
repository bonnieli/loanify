Rails.application.config.middleware.use OmniAuth::Builder do
  # if Rails.env.development?
  # 	provider :facebook, '1390894531173876', '3a11e6b74ab83671fe6014174cec2442'
  # else if Rails.env.production?
  # 	provider :facebook, '1390894531173876', '3a11e6b74ab83671fe6014174cec2442'
  # end
  provider :facebook, '1390894531173876', '3a11e6b74ab83671fe6014174cec2442'

  #provider :facebook, '1390894531173876', '3a11e6b74ab83671fe6014174cec2442',
  #           :scope => 'user_photos', :display => 'popup'
end