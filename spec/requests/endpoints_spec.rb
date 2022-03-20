require 'rails_helper'

RSpec.describe "Endpoints", type: :request do

  # create a user before the test scenarios are run
  let!(:user) { User.create(username: 'Babbel', authentication_token: '1btoken') }

  #It is a normal request Endpoint
  describe "GET /endpoints" do

    #Simple Rspec Testing
    it "works! (now write some real specs)" do
      get endpoints_path, headers: { 'Content-Type' => 'application/vnd.api+json', 'username' => user.username, 'tokens' => user.authentication_token }, xhr: true
      expect(response).to have_http_status(:success)
    end

    context 'unauthenticated user' do
      it 'should return user not found error' do
        get '/endpoints', params: nil, headers: { }

        # response should have HTTP Status 403 Forbidden
        expect(response.status).to eq(404)

        # response contain error message
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:errors][0][:detail]).to eq('Invalid User')
      end
    end

  end

  #For Further Depth Testing related to different important Endpoints request check Endpoint Folder

end
