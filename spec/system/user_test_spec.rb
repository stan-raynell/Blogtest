 require "rails_helper"

 RSpec.describe "User profile" do
  let!(:user) { create(:user) }

  it "should display user email and avatar" do
    login_as(user)
    visit(user_path(user))
    expect(page).to have_content(user.email)
    expect(page).to have_css(".gravatar")
  end
 end
