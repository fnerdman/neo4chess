require 'spec_helper'

describe "evaluations/edit" do
  before(:each) do
    @evaluation = assign(:evaluation, stub_model(Evaluation,
      :engine => "MyString",
      :centipawns => 1,
      :ply => 1,
      :nNodes => 1,
      :bestPath => "MyString"
    ))
  end

  it "renders the edit evaluation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", evaluation_path(@evaluation), "post" do
      assert_select "input#evaluation_engine[name=?]", "evaluation[engine]"
      assert_select "input#evaluation_centipawns[name=?]", "evaluation[centipawns]"
      assert_select "input#evaluation_ply[name=?]", "evaluation[ply]"
      assert_select "input#evaluation_nNodes[name=?]", "evaluation[nNodes]"
      assert_select "input#evaluation_bestPath[name=?]", "evaluation[bestPath]"
    end
  end
end
