require 'rails_helper'

RSpec.describe "bombermen/edit", type: :view do
  before(:each) do
    @bomberman = assign(:bomberman, Bomberman.create!(
      :lobbyid => "MyText"
    ))
  end

  it "renders the edit bomberman form" do
    render

    assert_select "form[action=?][method=?]", bomberman_path(@bomberman), "post" do

      assert_select "textarea#bomberman_lobbyid[name=?]", "bomberman[lobbyid]"
    end
  end
end
