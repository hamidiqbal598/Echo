class User < ApplicationRecord

  #Scope approach
  scope :get_user, -> (username, token) { where(username: username, authentication_token: token) }

end
