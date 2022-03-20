class Response < ApplicationRecord

  # Response relationship with Endpoint model
  has_one :endpoint

  # Validation as code presence is mandatory.
  validates :code, presence: true

end
