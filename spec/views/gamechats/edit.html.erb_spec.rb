require 'rails_helper'

RSpec.describe "gamechats/edit", type: :view do
  before(:each) do
    @gamechat = assign(:gamechat, Gamechat.create!(
      :lobbyid => "MyText",
      :message => "MyText"
    ))
  end

  it "renders the edit gamechat form" do
    render

    assert_select "form[action=?][method=?]", gamechat_path(@gamechat), "post" do

      assert_select "textarea#gamechat_lobbyid[name=?]", "gamechat[lobbyid]"

      assert_select "textarea#gamechat_message[name=?]", "gamechat[message]"
    end
  end
end
