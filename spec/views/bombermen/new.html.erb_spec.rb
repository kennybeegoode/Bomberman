require 'rails_helper'

RSpec.describe "bombermen/new", type: :view do
  before(:each) do
    assign(:bomberman, Bomberman.new(
      :lobbyid => "MyText"
    ))
  end

  it "renders new bomberman form" do
    render

    assert_select "form[action=?][method=?]", bombermen_path, "post" do

      assert_select "textarea#bomberman_lobbyid[name=?]", "bomberman[lobbyid]"
    end
  end
end
