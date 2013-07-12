require 'spec_helper'

describe "games/new" do
  before(:each) do
    assign(:game, stub_model(Game,
      :id => "MyString",
      :name => "MyString",
      :halfturns => 1,
      :result => "MyString",
      :mode => "MyString",
      :site => "MyString"
    ).as_new_record)
  end

  it "renders new game form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", games_path, "post" do
      assert_select "input#game_id[name=?]", "game[id]"
      assert_select "input#game_name[name=?]", "game[name]"
      assert_select "input#game_halfturns[name=?]", "game[halfturns]"
      assert_select "input#game_result[name=?]", "game[result]"
      assert_select "input#game_mode[name=?]", "game[mode]"
      assert_select "input#game_site[name=?]", "game[site]"
    end
  end
end
