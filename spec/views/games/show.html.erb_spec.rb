require 'spec_helper'

describe "games/show" do
  before(:each) do
    @game = assign(:game, stub_model(Game,
      :id => "Id",
      :name => "Name",
      :halfturns => 1,
      :result => "Result",
      :mode => "Mode",
      :site => "Site"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Id/)
    rendered.should match(/Name/)
    rendered.should match(/1/)
    rendered.should match(/Result/)
    rendered.should match(/Mode/)
    rendered.should match(/Site/)
  end
end
