require "rails_helper"

RSpec.describe GamechatsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/gamechats").to route_to("gamechats#index")
    end

    it "routes to #new" do
      expect(:get => "/gamechats/new").to route_to("gamechats#new")
    end

    it "routes to #show" do
      expect(:get => "/gamechats/1").to route_to("gamechats#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/gamechats/1/edit").to route_to("gamechats#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/gamechats").to route_to("gamechats#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/gamechats/1").to route_to("gamechats#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/gamechats/1").to route_to("gamechats#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/gamechats/1").to route_to("gamechats#destroy", :id => "1")
    end

  end
end
