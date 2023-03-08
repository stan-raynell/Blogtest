require "rails_helper"

RSpec.describe "Articles page" do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user, admin: true) }
  let!(:article) {
    create(:article,
           title: "Yay!",
           body: "Go Rails and GTFO!",
           status: "public",
           user: user)
  }
  let!(:article2) {
    create(:article,
           title: "Arch test",
           body: "Archived testing",
           status: "archived",
           user: user)
  }

  it "should display articles" do
    visit articles_path
    expect(page).to have_content(article.title)
  end

  it "should allow to open an article" do
    visit articles_path
    click_on(article.title)
    expect(page).to have_content("Go Rails and GTFO!")
  end

  it "should redirect to article creation page" do
    login_as(user)
    visit articles_path
    click_on("New Article")
    expect(current_path).to eq(new_article_path)
  end

  it "should not display archived articles" do
    visit articles_path
    expect(page).not_to have_content("Arch test")
  end

  it "should not display new article link without login" do
    visit articles_path
    expect(page).not_to have_content("New Article")
  end

  it "should display archived articles for admins" do
    login_as(user2)
    visit articles_path
    expect(page).to have_content("Arch test")
  end
end
