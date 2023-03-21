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

  it "should allow to make a comment and save it", :user1, :pub1 do
    refresh
    fill_in("comment_body", with: "A funny comment")
    click_on("Create Comment")
    expect(article_pub1.comments).not_to be_blank
    expect(page).to have_content("A funny comment")
  end

  it "should display alert for empty comment", :user1, :pub1 do
    refresh
    click_on("Create Comment")
    visit(article_path(article_pub1))
    expect(page).to have_content("Empty comment!")
  end

  it "should display previously made comments", :pub2 do
    refresh
    expect(page).to have_content("Just testing!")
  end

  it "should allow to delete comments", :user1, :pub2 do
    refresh
    click_on("Delete Comment")
    expect(page).not_to have_content("Just testing!")
  end

  it "should not display delete controls to another user", :user2, :pub2 do
    refresh
    expect(page).not_to have_content("Delete Comment")
  end

  it "should display delete controls for all comments to admins", :user_adm, :pub2 do
    refresh
    expect(page).to have_content("Delete Comment")
  end

  it "should allow admins to delete any comments", :user_adm, :pub2 do
    refresh
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
  it "should not display archived comments to regular users", :user1, :pub1 do
    refresh
    expect(page).not_to have_content("Archived comment")
  end

  it "should display archived comments to admins", :user_adm, :pub1 do
    refresh
    expect(page).to have_content("Archived comment")
  end

  it "should allow admins to delete archived comments", :user_adm, :pub1 do
    refresh
    click_on("Delete Comment")
    expect(page).not_to have_content("Archived comment")
  end

  it "should display private comments to their authors", :user1, :pub2 do
    refresh
    expect(page).to have_content("Private comment")
  end

  it "should not display private comments to other units", :user2, :pub2 do
    refresh
    expect(page).not_to have_content("Private comment")
  end

  it "should display private comments to admins", :user_adm, :pub2 do
    refresh
    expect(page).to have_content("Private comment")
  end

  it "should allow admins to delete private comments", :user_adm, :pub2 do
    refresh
    click_on("Delete Comment")
    expect(page).not_to have_content("Private comment")
  end
end
