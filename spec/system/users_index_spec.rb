# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users page" do
  let!(:user1) { create(:user) }
  let!(:user_adm) { create(:user, admin: true) }

  it "should list registered users" do
    sign_in(user1)
    visit(users_path)
    expect(page).to have_content(user1.email)
    expect(page).to have_content(user_adm.email)
    click_on(user1.email)
    expect(current_path).to eq(user_path(user1))
  end

  it "should display controls and allow admins to delete users" do
    sign_in(user_adm)
    visit(users_path)
    click_on("Delete user", match: :first)
    expect(page).not_to have_content(user1.email)
    expect(User.count).to eq(1)
  end

  it "should not display delete controls to regular users" do
    sign_in(user1)
    visit(users_path)
    expect(page).not_to have_content("Delete user")
  end
end
