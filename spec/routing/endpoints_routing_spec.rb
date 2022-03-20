require "rails_helper"

RSpec.describe EndpointsController, type: :routing do
  describe "routing" do

    # checking the index route of endpoint with controller and action
    it "routes to #index" do
      expect(:get => "/endpoints").to route_to(:controller => "endpoints", :action => "index", :format => :json)
    end

    # checking the new route of endpoint with direct route_to method
    it "routes to #new" do
      expect(:get => "/endpoints/new").to route_to("endpoints#new", :format => :json)
    end

    # checking the show route of endpoint with route_to method along with id
    it "routes to #show" do
      expect(:get => "/endpoints/1").to route_to("endpoints#show", :id => "1", :format => :json)
    end

    # checking the edit route of endpoint with route_to method along with id
    it "routes to #edit" do
      expect(:get => "/endpoints/1/edit").to route_to("endpoints#edit", :id => "1", :format => :json)
    end

    # checking the new create route of endpoint with direct route_to method
    it "routes to #create" do
      expect(:post => "/endpoints").to route_to("endpoints#create", :format => :json)
    end

    # checking the update route of endpoint with put request using direct route_to method along with id
    it "routes to #update via PUT" do
      expect(:put => "/endpoints/1").to route_to("endpoints#update", :id => "1", :format => :json)
    end

    # checking the update route of endpoint with patch request using route_to method along with id
    it "routes to #update via PATCH" do
      expect(:patch => "/endpoints/1").to route_to("endpoints#update", :id => "1", :format => :json)
    end

    # checking the delete route of endpoint with direct route_to method along with id
    it "routes to #destroy" do
      expect(:delete => "/endpoints/1").to route_to("endpoints#destroy", :id => "1", :format => :json)
    end

  end
end
