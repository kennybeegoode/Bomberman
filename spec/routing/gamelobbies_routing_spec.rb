require "rails_helper"

RSpec.describe GamelobbiesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/gamelobbies").to route_to("gamelobbies#index")
    end

    it "routes to #new" do
      expect(:get => "/gamelobbies/new").to route_to("gamelobbies#new")
    end

    it "routes to #show" do
      expect(:get => "/gamelobbies/1").to route_to("gamelobbies#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/gamelobbies/1/edit").to route_to("gamelobbies#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/gamelobbies").to route_to("gamelobbies#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/gamelobbies/1").to route_to("gamelobbies#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/gamelobbies/1").to route_to("gamelobbies#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/gamelobbies/1").to route_to("gamelobbies#destroy", :id => "1")
    end

  end
end
