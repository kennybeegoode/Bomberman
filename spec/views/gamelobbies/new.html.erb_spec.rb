require 'rails_helper'

RSpec.describe "gamelobbies/new", type: :view do
  before(:each) do
    assign(:gamelobby, Gamelobby.new(
      :lobbyid => "",
      :lobbyname => "",
      :public => "",
      :gamestarted => "",
      :usercount => "",
      :users => ""
    ))
  end

  it "renders new gamelobby form" do
    render

    assert_select "form[action=?][method=?]", gamelobbies_path, "post" do

      assert_select "input#gamelobby_lobbyid[name=?]", "gamelobby[lobbyid]"

      assert_select "input#gamelobby_lobbyname[name=?]", "gamelobby[lobbyname]"

      assert_select "input#gamelobby_public[name=?]", "gamelobby[public]"

      assert_select "input#gamelobby_gamestarted[name=?]", "gamelobby[gamestarted]"

      assert_select "input#gamelobby_usercount[name=?]", "gamelobby[usercount]"

      assert_select "input#gamelobby_users[name=?]", "gamelobby[users]"
    end
  end
end
