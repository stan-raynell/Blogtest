require "rails_helper"

RSpec.describe "Comment" do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user, admin: true) }
  let!(:article) do
    create(:article,
           title: "Yay!",
           body: "Go Rails and GTFO!",
           status: "public",
           user: user1)
  end
  let!(:article2) do
    create(:article,
           title: "Comm test",
           body: "Comments testing",
           status: "public",
           user: user1)
  end
  let!(:comment) do
    create(:comment,
           user: user1,
           body: "Just testing!",
           article: article2,
           status: "public")
  end
  let!(:comment2) do
    create(:comment,
           body: "Archived comment",
           article: article2,
           status: "archived",
           user: user1)
  end
  let!(:article3) do
    create(:article,
           title: "Admin rights",
           body: "Testing deleting",
           status: "public",
           user: user1)
  end
  let!(:comment3) do
    create(:comment,
           user: user1,
           body: "Testing administrator",
           article: article3,
           status: "public")
  end

  it "allows to make a comment and saves it" do
    sign_in(user1)
    visit(article_path(article))
    fill_in("comment_body", with: "A funny comment")
    select("public", from: "Status").select_option
    click_on("Create Comment")
    expect(article.comments).not_to be_blank
    expect(current_path).to eq(article_path(article))
    expect(page).to have_content("A funny comment")
  end

  it "displays previously made comments" do
    visit(article_path(article2))
    expect(page).to have_content("Just testing!")
  end

  it "should not display archived comments" do
    visit(article_path(article2))
    expect(page).not_to have_content("Archived comment")
  end

  it "allows to delete comments" do
    sign_in(user1)
    visit(article_path(article2))
    click_on("Destroy Comment")
    expect(page).not_to have_content("Just testing!")
  end

  it "should not display delete controls to another user" do
    sign_in(user2)
    visit(article_path(article2))
    expect(page).not_to have_content("Destroy")
  end

  it "should display archived comments to admins" do
    sign_in(user3)
    visit(article_path(article2))
    expect(page).to have_content("Archived comment")
  end

  it "should display delete controls for all comments to admins" do
    sign_in(user3)
    visit(article_path(article3))
    expect(page).to have_content("Destroy")
  end

  it "should allow admins to delete any comments" do
    sign_in(user3)
    visit(article_path(article3))
    click_on("Destroy Comment")
    expect(page).not_to have_content("Testing administrator")
  end
end
