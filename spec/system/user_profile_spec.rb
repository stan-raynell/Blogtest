# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User profile" do
  let!(:user1) { create(:user) }
  let!(:user_adm) { create(:user, admin: true) }

  before(:each) do
    visit(user_path(user1))
  end

  it "should display user email and avatar", :user1 do
    expect(page).to have_content(user1.email)
    expect(page).to have_css(".gravatar")
  end

  it "should show delete controls for current user", :user1 do
    expect(page).to have_content("Delete profile")
  end

  it "should show delete controls for admins", :user_adm do
    expect(page).to have_content("Delete profile")
  end

  it "should not show delete controls to another user", :user1 do
    visit(user_path(user_adm))
    expect(page).not_to have_content("Delete profile")
  end

  it "should delete user profile upon clicking delete", :user1 do
    click_on("Delete profile")
    expect(User.count).to eq(1)
    expect(current_path).to eq(root_path)
  end
end
