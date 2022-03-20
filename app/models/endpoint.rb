class Endpoint < ApplicationRecord

  # List of Possible Verbs in HTTP on the basis of https://tools.ietf.org/html/rfc7231#section-4.3
  POSSIBLE_VERBS = ['GET','POST','OPTION','PUT','PATCH','DELETE','COPY','HEAD','OPTIONS','PROPFIND','UNLOCK','LOCK']


  has_one :response, dependent: :destroy

  # Implemented Validations for required keys and their format and inclusion as well.
  validates :requested_verb, presence: true, inclusion: { in: POSSIBLE_VERBS }
  validates :requested_path, presence: true, format: { with: /\A[\/]/ }

  # Validate presence of nested attribute response bcz code is imp
  validates_presence_of :response
  accepts_nested_attributes_for :response, reject_if: :all_blank

  # scopes to make code less fatty in controller
  scope :get_with_verb, -> (verb) { where('lower(requested_verb) = ?', verb.downcase) }
  scope :get_with_path, -> (path) { where('lower(requested_path) = ?', path.downcase) }

end
