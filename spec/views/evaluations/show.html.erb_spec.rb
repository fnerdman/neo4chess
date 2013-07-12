require 'spec_helper'

describe "evaluations/show" do
  before(:each) do
    @evaluation = assign(:evaluation, stub_model(Evaluation,
      :engine => "Engine",
      :centipawns => 1,
      :ply => 2,
      :nNodes => 3,
      :bestPath => "Best Path"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Engine/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/Best Path/)
  end
end
