require 'rails_helper'

RSpec.describe "works/new", type: :view do
  before(:each) do
    assign(:work, Work.new(
      :title => "MyString",
      :pr => "MyText"
    ))
  end

  it "renders new work form" do
    render

    assert_select "form[action=?][method=?]", works_path, "post" do

      assert_select "input[name=?]", "work[title]"

      assert_select "textarea[name=?]", "work[pr]"
    end
  end
end
