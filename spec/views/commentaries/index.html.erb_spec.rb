require 'spec_helper'

describe "commentaries/index" do
  before(:each) do
    assign(:commentaries, [
      stub_model(Commentary,
        :title => "Title",
        :body => "Body"
      ),
      stub_model(Commentary,
        :title => "Title",
        :body => "Body"
      )
    ])
  end

  it "renders a list of commentaries" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Body".to_s, :count => 2
  end
end
