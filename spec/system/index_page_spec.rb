# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Articles page" do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user_adm) { create(:user, admin: true) }
  let!(:article_pub) do
    create(:article, title: "Yay!", body: "Go Rails and GTFO!",
                     status: "public",
                     user: user1)
  end
  let!(:article2) do
    create(:article, title: "Arch test", body: "Archived testing",
                     status: "archived",
                     user: user1)
  end
  let!(:article_priv) do
    create(:article, title: "Priv test", body: "Private testing",
                     status: "private",
                     user: user1)
  end

  before(:each) do
    visit articles_path
  end

  it "should display articles" do
    expect(page).to have_content(article_pub.title)
  end

  it "should allow to open an article" do
    click_on(article_pub.title)
    expect(page).to have_content("Go Rails and GTFO!")
  end

  it "should redirect to article creation page", :user1 do
    click_on("New Article")
    expect(current_path).to eq(new_article_path)
  end

  it "should not display archived articles" do
    expect(page).not_to have_content("Arch test")
  end

  it "should not display new article link without login" do
    expect(page).not_to have_content("New Article")
  end

  it "should display archived articles for admins", :user_adm do
    expect(page).to have_content("Arch test")
  end

  it "should display a link to the users list", :user1 do
    expect(page).to have_link("Users")
    click_on("Users")
    expect(current_path).to eq(users_path)
  end

  it "should display private articles to authors only", :user1 do
    expect(page).to have_content("Priv test")
    sign_in(user2)
    visit articles_path
    expect(page).not_to have_content("Priv test")
  end

  it "should display private articles to admins", :user_adm do
    expect(page).to have_content("Priv test")
    expect(page).to have_content("private")
  end
end
