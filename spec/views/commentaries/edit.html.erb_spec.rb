require 'spec_helper'

describe "commentaries/edit" do
  before(:each) do
    @commentary = assign(:commentary, stub_model(Commentary,
      :title => "MyString",
      :body => "MyString"
    ))
  end

  it "renders the edit commentary form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", commentary_path(@commentary), "post" do
      assert_select "input#commentary_title[name=?]", "commentary[title]"
      assert_select "input#commentary_body[name=?]", "commentary[body]"
    end
  end
end
