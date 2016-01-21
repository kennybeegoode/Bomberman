require 'rails_helper'

RSpec.describe "gamelobbies/edit", type: :view do
  before(:each) do
    @gamelobby = assign(:gamelobby, Gamelobby.create!(
      :lobbyid => "",
      :lobbyname => "",
      :public => "",
      :gamestarted => "",
      :usercount => "",
      :users => ""
    ))
  end

  it "renders the edit gamelobby form" do
    render

    assert_select "form[action=?][method=?]", gamelobby_path(@gamelobby), "post" do

      assert_select "input#gamelobby_lobbyid[name=?]", "gamelobby[lobbyid]"

      assert_select "input#gamelobby_lobbyname[name=?]", "gamelobby[lobbyname]"

      assert_select "input#gamelobby_public[name=?]", "gamelobby[public]"

      assert_select "input#gamelobby_gamestarted[name=?]", "gamelobby[gamestarted]"

      assert_select "input#gamelobby_usercount[name=?]", "gamelobby[usercount]"

      assert_select "input#gamelobby_users[name=?]", "gamelobby[users]"
    end
  end
end
