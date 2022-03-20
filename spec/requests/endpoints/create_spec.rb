# spec/requests/endpoints/create_spec.rb
require 'rails_helper'

describe 'It is an API Request named POST /endpoints' do
  feature 'POST /endpoints' do

    # create a user before the test scenarios are run
    let!(:user) { User.create(username: 'Babbel', authentication_token: '1btoken') }

    scenario 'valid endpoint attributes' do
      raw_body = ' {
        "data": {
          "type": "endpoints",
          "attributes": {
            "verb": "get",
            "path": "/greeting",
            "response": {
              "code": 200,
              "headers": {},
              "body": "\"{ \"message\": \"Hello, world\" }\""
            }
          }
        }
      } '
      # The controller will treat them as JSON
      post '/endpoints', params: raw_body, headers: { 'Content-Type' => 'application/vnd.api+json', 'username' => user.username, 'tokens' => user.authentication_token }

      # response should have HTTP Status 201 Created
      expect(response.status).to eq(201)

      json = JSON.parse(response.body).deep_symbolize_keys

      # check the value of the returned response hash
      expect(json[:data][:attributes][:verb]).to eq('GET')
      expect(json[:data][:attributes][:path]).to eq('/greeting')

      # 1 new endpoint record is created
      expect(Endpoint.count).to eq(1)

      # Optionally, you can check the latest record data
      expect(Endpoint.last.requested_verb).to eq('GET')
    end

    scenario 'invalid endpoint attribute with missing verb' do
      raw_body = ' {
        "data": {
          "type": "endpoints",
          "attributes": {
            "path": "/greeting",
            "response": {
              "code": 200,
              "headers": {},
              "body": "\"{ \"message\": \"Hello, world\" }\""
            }
          }
        }
      } '
      # The controller will treat them as JSON
      post '/endpoints', params: raw_body, headers: { 'Content-Type' => 'application/vnd.api+json', 'username' => user.username, 'tokens' => user.authentication_token }

      # response should have HTTP Status 404 bcz it's not created
      expect(response.status).to eq(404)

      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:errors][0][:code]).to eq("not_found")

      # no new endpoint record is created
      expect(Endpoint.count).to eq(0)
    end
  end

end
