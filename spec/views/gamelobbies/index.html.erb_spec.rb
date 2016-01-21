require 'rails_helper'

RSpec.describe "gamelobbies/index", type: :view do
  before(:each) do
    assign(:gamelobbies, [
      Gamelobby.create!(
        :lobbyid => "",
        :lobbyname => "",
        :public => "",
        :gamestarted => "",
        :usercount => "",
        :users => ""
      ),
      Gamelobby.create!(
        :lobbyid => "",
        :lobbyname => "",
        :public => "",
        :gamestarted => "",
        :usercount => "",
        :users => ""
      )
    ])
  end

  it "renders a list of gamelobbies" do
    render
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
