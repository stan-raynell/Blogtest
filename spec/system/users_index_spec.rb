require "rails_helper"

RSpec.describe "Users page" do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user, admin: true) }

  it "should list registered users" do
    sign_in(user)
    visit(users_path)
    expect(page).to have_content(user.email)
    expect(page).to have_content(user2.email)
    click_on(user.email)
    expect(current_path).to eq(user_path(user))
  end

  it "should display delete controls for admins" do
    sign_in(user2)
    visit(users_path)
    expect(page).to have_content("Delete user")
    click_on("Delete user", match: :first)
    expect(page).not_to have_content(user.email)
    expect(User.count).to eq(1)
  end
end
