require 'rails_helper'

RSpec.describe "bombermen/index", type: :view do
  before(:each) do
    assign(:bombermen, [
      Bomberman.create!(
        :lobbyid => "MyText"
      ),
      Bomberman.create!(
        :lobbyid => "MyText"
      )
    ])
  end

  it "renders a list of bombermen" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
