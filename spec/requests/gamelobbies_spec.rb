require 'rails_helper'

RSpec.describe "Gamelobbies", type: :request do
  describe "GET /gamelobbies" do
    it "works! (now write some real specs)" do
      get gamelobbies_path
      expect(response).to have_http_status(200)
    end
  end
end
