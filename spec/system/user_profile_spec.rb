require "rails_helper"

RSpec.describe "User profile" do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user, admin: true) }

  it "should display user email and avatar" do
    sign_in(user1)
    visit(user_path(user1))
    expect(page).to have_content(user1.email)
    expect(page).to have_css(".gravatar")
  end

  it "should show delete controls for current user and admin" do
    sign_in(user1)
    visit(user_path(user1))
    expect(page).to have_content("Delete profile")
    visit(user_path(user2))
    expect(page).not_to have_content("Delete profile")
    sign_out(user1)
    visit(user_path(user1))
    expect(page).not_to have_content("Delete profile")
    sign_in(user2)
    visit(user_path(user1))
    expect(page).to have_content("Delete profile")
  end

  it "should delete user profile upon clicking delete" do
    sign_in(user1)
    visit(user_path(user1))
    click_on("Delete profile")
    expect(User.count).to eq(1)
    expect(current_path).to eq(root_path)
  end
end
