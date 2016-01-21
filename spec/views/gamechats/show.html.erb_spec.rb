require 'rails_helper'

RSpec.describe "gamechats/show", type: :view do
  before(:each) do
    @gamechat = assign(:gamechat, Gamechat.create!(
      :lobbyid => "MyText",
      :message => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end
