require "rails_helper"

RSpec.describe "Articles page" do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user, admin: true) }
  let!(:user3) { create(:user) }
  let!(:article) do
    create(:article,
           title: "Yay!",
           body: "Go Rails and GTFO!",
           status: "public",
           user: user)
  end
  let!(:article2) do
    create(:article,
           title: "Arch test",
           body: "Archived testing",
           status: "archived",
           user: user)
  end
  let!(:article3) do
    create(:article,
           title: "Priv test",
           body: "Private testing",
           status: "private",
           user: user)
  end

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
    sign_in(user)
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
    sign_in(user2)
    visit articles_path
    expect(page).to have_content("Arch test")
  end

  it "should display a link to the users list" do
    sign_in(user)
    visit articles_path
    expect(page).to have_link("Users")
    click_on("Users")
    expect(current_path).to eq(users_path)
  end

  it "should display private articles to authors only" do
    sign_in(user)
    visit articles_path
    expect(page).to have_content("Priv test")
    sign_out(user)
    visit articles_path
    expect(page).not_to have_content("Priv test")
    sign_in(user3)
    expect(page).not_to have_content("Priv test")
  end

  it "should display private articles to admins" do
    sign_in(user2)
    visit articles_path
    expect(page).to have_content("Priv test")
    expect(page).to have_content("private")
  end
end
