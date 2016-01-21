require 'rails_helper'

RSpec.describe "Bombermen", type: :request do
  describe "GET /bombermen" do
    it "works! (now write some real specs)" do
      get bombermen_path
      expect(response).to have_http_status(200)
    end
  end
end
