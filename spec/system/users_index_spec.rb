# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users page" do
  let!(:user1) { create(:user) }
  let!(:user_adm) { create(:user, admin: true) }

  before(:each) do
    visit(users_path)
  end

  it "should list registered users", :user1 do
    expect(page).to have_link(user1.email).and have_link(user_adm.email)
  end

  it "should display controls and allow admins to delete users", :user_adm do
    click_on("Delete user", match: :first)
    expect(page).not_to have_content(user1.email)
    expect(User.count).to eq(1)
  end

  it "should not display delete controls to regular users", :user1 do
    expect(page).not_to have_content("Delete user")
  end
end
