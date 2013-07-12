require 'spec_helper'

describe "evaluations/new" do
  before(:each) do
    assign(:evaluation, stub_model(Evaluation,
      :engine => "MyString",
      :centipawns => 1,
      :ply => 1,
      :nNodes => 1,
      :bestPath => "MyString"
    ).as_new_record)
  end

  it "renders new evaluation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", evaluations_path, "post" do
      assert_select "input#evaluation_engine[name=?]", "evaluation[engine]"
      assert_select "input#evaluation_centipawns[name=?]", "evaluation[centipawns]"
      assert_select "input#evaluation_ply[name=?]", "evaluation[ply]"
      assert_select "input#evaluation_nNodes[name=?]", "evaluation[nNodes]"
      assert_select "input#evaluation_bestPath[name=?]", "evaluation[bestPath]"
    end
  end
end
