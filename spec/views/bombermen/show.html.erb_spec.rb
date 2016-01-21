require 'rails_helper'

RSpec.describe "bombermen/show", type: :view do
  before(:each) do
    @bomberman = assign(:bomberman, Bomberman.create!(
      :lobbyid => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
  end
end
