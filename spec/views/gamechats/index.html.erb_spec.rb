require 'rails_helper'

RSpec.describe "gamechats/index", type: :view do
  before(:each) do
    assign(:gamechats, [
      Gamechat.create!(
        :lobbyid => "MyText",
        :message => "MyText"
      ),
      Gamechat.create!(
        :lobbyid => "MyText",
        :message => "MyText"
      )
    ])
  end

  it "renders a list of gamechats" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
