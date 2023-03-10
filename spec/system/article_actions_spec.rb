require "rails_helper"

RSpec.describe "Article page" do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user, admin: true) }
  let!(:article) do
    create(:article,
           title: "Yay!",
           body: "Go Rails and GTFO!",
           status: "public",
           user:)
  end
  let!(:bad_article) do
    build(:article,
          title: "", body: "foo",
          status: "public",
          user:)
  end
  let!(:article2) do
    create(:article,
           title: "Comm test",
           body: "Destroy testing",
           status: "public",
           user: user2)
  end

  it "should properly save new article contents" do
    sign_in(user)
    visit new_article_path
    fill_in("Title", with: "Stoned")
    fill_in("Body", with: "I'm so fucking stoned!")
    select("public", from: "Status").select_option
    click_on("Create Article")
    expect(Article.last.title).to eq("Stoned")
    expect(Article.last.body).to eq("I'm so fucking stoned!")
  end

  it "should prevent saving invalid data" do
    expect(bad_article.save).to be_falsy
  end

  it "should allow to edit your article" do
    sign_in(user)
    visit article_path(article)
    click_on("Edit")
    expect(current_path).to eq(edit_article_path(article))
    fill_in("Body", with: "I'm so fucking edited!")
    select("public", from: "Status").select_option
    click_on("Update Article")
    expect(current_path).to eq(article_path(article))
    expect(page).to have_content("I'm so fucking edited!")
    article.reload
    expect(article.body).to eq("I'm so fucking edited!")
  end

  it "should allow to delete your article" do
    sign_in(user)
    visit article_path(article)
    click_on("Delete")
    expect(Article.count).to eq(1)
    expect(current_path).to eq(root_path)
  end

  it "should not display article controls to another user" do
    sign_in(user)
    visit article_path(article2)
    expect(page).not_to have_content("Delete")
    expect(page).not_to have_content("Edit")
  end

  it "should diplay any article controls to admins" do
    sign_in(user3)
    visit article_path(article)
    expect(page).to have_content("Delete")
    expect(page).to have_content("Edit")
  end

  it "should allow admin to delete any article" do
    sign_in(user3)
    visit article_path(article)
    click_on("Delete")
    expect(Article.count).to eq(1)
    expect(current_path).to eq(root_path)
  end
end
