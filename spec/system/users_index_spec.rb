require "rails_helper"

RSpec.describe "Users page" do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user, admin: true) }

  it "should list registered users" do
    sign_in(user1)
    visit(users_path)
    expect(page).to have_content(user1.email)
    expect(page).to have_content(user2.email)
    click_on(user1.email)
    expect(current_path).to eq(user_path(user1))
  end

  it "should display delete controls for admins" do
    sign_in(user2)
    visit(users_path)
    expect(page).to have_content("Delete user")
    click_on("Delete user", match: :first)
    expect(page).not_to have_content(user1.email)
    expect(User.count).to eq(1)
  end
end
