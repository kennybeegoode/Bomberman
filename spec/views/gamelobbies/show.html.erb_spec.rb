require 'rails_helper'

RSpec.describe "gamelobbies/show", type: :view do
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

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
