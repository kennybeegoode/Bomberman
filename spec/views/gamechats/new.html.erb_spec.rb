require 'rails_helper'

RSpec.describe "gamechats/new", type: :view do
  before(:each) do
    assign(:gamechat, Gamechat.new(
      :lobbyid => "MyText",
      :message => "MyText"
    ))
  end

  it "renders new gamechat form" do
    render

    assert_select "form[action=?][method=?]", gamechats_path, "post" do

      assert_select "textarea#gamechat_lobbyid[name=?]", "gamechat[lobbyid]"

      assert_select "textarea#gamechat_message[name=?]", "gamechat[message]"
    end
  end
end
