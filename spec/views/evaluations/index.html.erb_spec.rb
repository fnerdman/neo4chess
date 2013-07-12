require 'spec_helper'

describe "evaluations/index" do
  before(:each) do
    assign(:evaluations, [
      stub_model(Evaluation,
        :engine => "Engine",
        :centipawns => 1,
        :ply => 2,
        :nNodes => 3,
        :bestPath => "Best Path"
      ),
      stub_model(Evaluation,
        :engine => "Engine",
        :centipawns => 1,
        :ply => 2,
        :nNodes => 3,
        :bestPath => "Best Path"
      )
    ])
  end

  it "renders a list of evaluations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Engine".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Best Path".to_s, :count => 2
  end
end
