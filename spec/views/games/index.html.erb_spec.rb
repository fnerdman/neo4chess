require 'spec_helper'

describe "games/index" do
  before(:each) do
    assign(:games, [
      stub_model(Game,
        :id => "Id",
        :name => "Name",
        :halfturns => 1,
        :result => "Result",
        :mode => "Mode",
        :site => "Site"
      ),
      stub_model(Game,
        :id => "Id",
        :name => "Name",
        :halfturns => 1,
        :result => "Result",
        :mode => "Mode",
        :site => "Site"
      )
    ])
  end

  it "renders a list of games" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Id".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Result".to_s, :count => 2
    assert_select "tr>td", :text => "Mode".to_s, :count => 2
    assert_select "tr>td", :text => "Site".to_s, :count => 2
  end
end
