# spec/requests/endpoints/create_spec.rb
require 'rails_helper'

describe 'It is an API Request named PUT /endpoints' do
  describe 'PUT /endpoints' do

    # this will create a 'endpoint' method, which return the created endpoint object,
    let!(:endpoint) { Endpoint.create(:requested_type=>"endpoints", :requested_verb=>"PUT", :requested_path=>"/update_spec_test", :response_attributes=>{"code"=>201, "headers"=>{}, "body"=>"\"{ \"message\": \"Hello, everyone\" }\""}) }

    # create a user before the test scenarios are run
    let!(:user) { User.create(username: 'Babbel', authentication_token: '1btoken') }

    scenario 'valid endpoint attributes' do
      raw_body = '{
        "data": {
            "type": "endpoints",
            "id": "1",
            "attributes": {
                "verb": "PATCH",
                "path": "/after_update_spec_test",
                "response": {
                    "code": 201,
                    "headers": {},
                    "body": "\"{ \"message\": \"Hello, everyone\" }\""
                }
            }
        }
      }'
      # The controller will treat them as JSON
      put "/endpoints/#{endpoint.id}", params: raw_body, headers: { 'Content-Type' => 'application/vnd.api+json', 'username' => user.username, 'tokens' => user.authentication_token }

      # response should have HTTP Status 201 Created
      expect(response.status).to eq(200)

      json = JSON.parse(response.body).deep_symbolize_keys

      # check the value of the returned response hash
      expect(json[:data][:attributes][:verb]).to eq('PATCH')
      expect(json[:data][:attributes][:path]).to eq('/after_update_spec_test')

      # The endpoint requested_path and requested_verb should be updated
      expect(endpoint.reload.requested_path).to eq('/after_update_spec_test')
      expect(endpoint.reload.requested_verb).to eq('PATCH')

    end

  end

end
