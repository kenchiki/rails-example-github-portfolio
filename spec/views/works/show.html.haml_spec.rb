require 'rails_helper'

RSpec.describe "works/show", type: :view do
  before(:each) do
    @work = assign(:work, Work.create!(
      :title => "Title",
      :pr => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
  end
end
