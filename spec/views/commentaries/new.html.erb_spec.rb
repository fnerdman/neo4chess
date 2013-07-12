require 'spec_helper'

describe "commentaries/new" do
  before(:each) do
    assign(:commentary, stub_model(Commentary,
      :title => "MyString",
      :body => "MyString"
    ).as_new_record)
  end

  it "renders new commentary form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", commentaries_path, "post" do
      assert_select "input#commentary_title[name=?]", "commentary[title]"
      assert_select "input#commentary_body[name=?]", "commentary[body]"
    end
  end
end
