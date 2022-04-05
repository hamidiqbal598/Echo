require 'rails_helper'

RSpec.describe Response, :type => :model do

  # Here we make object for a dummy data to validate it further
  let(:valid_attributes) {
    {
      "code": 200,
      "headers": {},
      "body": "\"{ \"message\": \"Hello, world\" }\""
    }
  }

  context "validation_with_proper_attribute_values" do

    # Here we are creating new response object
    let(:response) { Response.new(valid_attributes) }

    # It Validates the created dummy response have code in it or not
    it "requires an code" do
      expect(response).to validate_presence_of(:code)
    end
  end

end
