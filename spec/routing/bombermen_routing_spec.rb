require "rails_helper"

RSpec.describe BombermenController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/bombermen").to route_to("bombermen#index")
    end

    it "routes to #new" do
      expect(:get => "/bombermen/new").to route_to("bombermen#new")
    end

    it "routes to #show" do
      expect(:get => "/bombermen/1").to route_to("bombermen#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/bombermen/1/edit").to route_to("bombermen#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/bombermen").to route_to("bombermen#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/bombermen/1").to route_to("bombermen#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/bombermen/1").to route_to("bombermen#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/bombermen/1").to route_to("bombermen#destroy", :id => "1")
    end

  end
end
