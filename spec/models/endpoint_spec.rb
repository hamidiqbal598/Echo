require 'rails_helper'

RSpec.describe Endpoint, :type => :model do

  # Here we make object for a dummy data to validate it further
  let(:valid_attributes) {
    {
      requested_type: "endpoints",
      requested_path: "/agreeting",
      requested_verb: "get",
      response_attributes: {
        "code": 200,
        "headers": {},
        "body": "\"{ \"message\": \"Hello, world\" }\""
      }
    }
  }

  context "validation_with_proper_attribute_values" do

    # Here we are creating new endpoint object
    let(:endpoint) { Endpoint.new(valid_attributes) }

    # It Validates the created dummy endpoint carrying verb or not
    it "requires an verb" do
      expect(endpoint).to validate_presence_of(:requested_verb)
    end

    # It Validates the created dummy endpoint carrying path or not
    it "requires an path" do
      expect(endpoint).to validate_presence_of(:requested_path)
    end

    # It Validates the created dummy endpoint carrying response or not
    it "requires an response" do
      expect(endpoint).to validate_presence_of(:response)
    end

    # It Validates the created dummy endpoint have proper path
    it "requires the path to look like a proper path" do
      endpoint.requested_path = "xyz"
      expect(endpoint).to_not be_valid
    end

    # It Validates the created dummy endpoint carrying verb included in the list of verb or not
    it "should allow valid values" do
      Endpoint::POSSIBLE_VERBS.each do |v|
        should allow_value(v).for(:requested_verb)
      end
    end

  end

end
