# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Public comments interface" do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user_adm) { create(:user, admin: true) }
  let!(:article_pub1) do
    create(:article, title: "Yay!", body: "Go Rails and GTFO!",
                     status: "public",
                     user: user1)
  end
  let!(:article_pub2) do
    create(:article, title: "Comm test", body: "Comments testing",
                     status: "public",
                     user: user1)
  end
  let!(:comment_pub1) do
    create(:comment, user: user1, body: "Just testing!",
                     article: article_pub2,
                     status: "public")
  end

  it "allows to make a comment and saves it" do
    sign_in(user1)
    visit(article_path(article_pub1))
    fill_in("comment_body", with: "A funny comment")
    select("public", from: "Status").select_option
    click_on("Create Comment")
    expect(article_pub1.comments).not_to be_blank
    expect(current_path).to eq(article_path(article_pub1))
    expect(page).to have_content("A funny comment")
  end

  it "displays previously made comments" do
    visit(article_path(article_pub2))
    expect(page).to have_content("Just testing!")
  end

  it "allows to delete comments" do
    sign_in(user1)
    visit(article_path(article_pub2))
    click_on("Delete Comment")
    expect(page).not_to have_content("Just testing!")
  end

  it "should not display delete controls to another user" do
    sign_in(user2)
    visit(article_path(article_pub2))
    expect(page).not_to have_content("Delete Comment")
  end

  it "should display delete controls for all comments to admins" do
    sign_in(user_adm)
    visit(article_path(article_pub2))
    expect(page).to have_content("Delete Comment")
  end

  it "should allow admins to delete any comments" do
    sign_in(user_adm)
    visit(article_path(article_pub2))
    click_on("Delete Comment")
    expect(page).not_to have_content("Just testing!")
  end
end

describe "Archived and private comments interface" do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user_adm) { create(:user, admin: true) }
  let!(:article_pub1) do
    create(:article,
           title: "Comm test",
           body: "Comments testing",
           status: "public",
           user: user1)
  end
  let!(:article_pub2) do
    create(:article,
           title: "Comm test",
           body: "Comments testing",
           status: "public",
           user: user1)
  end
  let!(:comment_arch) do
    create(:comment,
           body: "Archived comment",
           article: article_pub1,
           status: "archived",
           user: user1)
  end
  let!(:comment_priv) do
    create(:comment,
           body: "Private comment",
           article: article_pub2,
           status: "private",
           user: user1)
  end
  it "should not display archived comments to regular users" do
    visit(article_path(article_pub1))
    expect(page).not_to have_content("Archived comment")
    sign_in(user1)
    visit(article_path(article_pub1))
    expect(page).not_to have_content("Archived comment")
  end

  it "should display archived comments to admins" do
    sign_in(user_adm)
    visit(article_path(article_pub1))
    expect(page).to have_content("Archived comment")
  end

  it "should allow admins to delete archived comments" do
    sign_in(user_adm)
    visit(article_path(article_pub1))
    click_on("Delete Comment")
    expect(page).not_to have_content("Archived comment")
  end

  it "should display private comments only to their authors" do
    sign_in(user1)
    visit(article_path(article_pub2))
    expect(page).to have_content("Private comment")
    sign_in(user2)
    visit(article_path(article_pub2))
    expect(page).not_to have_content("Private comment")
  end

  it "should display private comments to admins" do
    sign_in(user_adm)
    visit(article_path(article_pub2))
    expect(page).to have_content("Private comment")
  end

  it "should allow admins to delete private comments" do
    sign_in(user_adm)
    visit(article_path(article_pub2))
    click_on("Delete Comment")
    expect(page).not_to have_content("Private comment")
  end
end
