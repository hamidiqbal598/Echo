# spec/requests/endpoints/create_spec.rb
require 'rails_helper'

describe 'It is an API Request named any request type which is created and give the respected response' do

  # create a user before the test scenarios are run
  let!(:user) { User.create(username: 'Hamid', authentication_token: '3btoken') }

  describe 'GET /hello' do

    # this will create a 'endpoint' method, which return the created endpoint object,
    let!(:endpoint) { Endpoint.create(:requested_type=>"endpoints", :requested_verb=>"GET", :requested_path=>"/hello", :response_attributes=>{"code"=>201, "headers"=>{}, "body"=>"\"{ \"message\": \"It's Get Request with Hello Path\" }\""}) }

    scenario 'Valid client requests the recently created endpoint in the test case' do

      # The controller will treat them as JSON
      get "/hello", params: nil, headers: { 'Accept' => 'application/json', 'username' => user.username, 'tokens' => user.authentication_token }

      # response should have HTTP Status 200 Findout the requested result
      expect(response.status).to eq(200)

      json = JSON.parse(response.body).deep_symbolize_keys

      # check the value of the returned response hash
      expect(json[:message]).to eq("It's Get Request with Hello Path")

    end

    scenario 'Invalid client requests the recently created endpoint in the test case' do

      # The controller will treat them as JSON
      post "/hello", params: nil, headers: { 'Accept' => 'application/json', 'username' => user.username, 'tokens' => user.authentication_token }

      # response should have HTTP Status 404 not found
      expect(response.status).to eq(404)

      json = JSON.parse(response.body).deep_symbolize_keys

      # check the value of the returned response hash error
      expect(json[:errors][0][:code]).to eq("not_found")

    end

  end


  describe 'OPTIONS /one_more_url' do

    # this will create a 'endpoint' method, which return the created endpoint object,
    let!(:endpoint) { Endpoint.create(:requested_type=>"endpoints", :requested_verb=>"OPTIONS", :requested_path=>"/one_more_url", :response_attributes=>{"code"=>201, "headers"=>{}, "body"=>"\"{ \"message\": \"It's OPTIONS Request with One More Url Path\" }\""}) }

    scenario 'Valid client requests the recently created endpoint in the test case' do

      # The controller will treat them as JSON
      options "/one_more_url", params: nil, headers: { 'Accept' => 'application/json', 'username' => user.username, 'tokens' => user.authentication_token }

      # response should have HTTP Status 200 Find out the requested result
      expect(response.status).to eq(200)

      json = JSON.parse(response.body).deep_symbolize_keys

      # check the value of the returned response hash
      expect(json[:message]).to eq("It's OPTIONS Request with One More Url Path")

    end

    scenario 'Invalid client request path compared to recently created endpoint in the test case' do

      # The controller will treat them as JSON
      options "/wrong_url", params: nil, headers: { 'Accept' => 'application/json', 'username' => user.username, 'tokens' => user.authentication_token }

      # response should have HTTP Status 404 not found
      expect(response.status).to eq(404)

      json = JSON.parse(response.body).deep_symbolize_keys

      # check the value of the returned response hash error
      expect(json[:errors][0][:code]).to eq("not_found")

    end

  end

end
