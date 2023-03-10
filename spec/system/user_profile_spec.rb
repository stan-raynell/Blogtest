require "rails_helper"

RSpec.describe "User profile" do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user, admin: true) }

  it "should display user email and avatar" do
    sign_in(user)
    visit(user_path(user))
    expect(page).to have_content(user.email)
    expect(page).to have_css(".gravatar")
  end

  it "should show delete controls for current user and admin" do
    sign_in(user)
    visit(user_path(user))
    expect(page).to have_content("Delete profile")
    visit(user_path(user2))
    expect(page).not_to have_content("Delete profile")
    sign_out(user)
    visit(user_path(user))
    expect(page).not_to have_content("Delete profile")
    sign_in(user2)
    visit(user_path(user))
    expect(page).to have_content("Delete profile")
  end

  it "should delete user profile upon clicking delete" do
    sign_in(user)
    visit(user_path(user))
    click_on("Delete profile")
    expect(User.count).to eq(1)
    expect(current_path).to eq(root_path)
  end
end
