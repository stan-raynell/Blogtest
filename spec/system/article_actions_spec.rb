# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Public articles interface" do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user_adm) { create(:user, admin: true) }
  let!(:article_pub1) do
    create(:article, title: "Yay!", body: "Go Rails and GTFO!",
                     status: "public", user: user1)
  end
  let!(:bad_article) do
    build(:article, title: "", body: "foo", status: "public", user: user1)
  end
  let!(:article_pub2) do
    create(:article, title: "Comm test", body: "Destroy testing",
                     status: "public",
                     user: user1)
  end

  def delete_page
    visit article_path(article_pub1)
    click_on("Delete")
    expect(Article.count).to eq(1)
    expect(current_path).to eq(root_path)
  end

  it "should properly save new article contents", :user1 do
    visit new_article_path
    fill_in("Title", with: "Stoned")
    fill_in("Body", with: "I'm so fucking stoned!")
    select("public", from: "Status").select_option
    click_on("Create Article")
    expect(Article.last.body).to eq("I'm so fucking stoned!")
  end

  it "should prevent saving invalid data" do
    expect(bad_article.save).to be_falsy
  end

  it "should allow to edit your article", :user1, :pub1 do
    click_on("Edit")
    expect(current_path).to eq(edit_article_path(article_pub1))
    fill_in("Body", with: "I'm so fucking edited!")
    click_on("Update Article")
    article_pub1.reload
    expect(article_pub1.body).to eq("I'm so fucking edited!")
  end

  it "should allow to delete your article", :user1 do
    delete_page
  end

  it "should not display article controls to another user", :user2, :pub2 do
    expect(page).not_to have_content("Delete")
    expect(page).not_to have_content("Edit")
  end

  it "should diplay any article controls to admins", :user_adm, :pub1 do
    expect(page).to have_content("Delete")
    expect(page).to have_content("Edit")
  end

  it "should allow admin to delete any article", :user_adm do
    delete_page
  end
end

describe "Archived and private articles interface" do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user_adm) { create(:user, admin: true) }
  let!(:article_priv) do
    create(:article, title: "Priv test", body: "Private testing",
                     status: "private",
                     user: user1)
  end
  let!(:article_arch) do
    create(:article, title: "Arch test", body: "Archived testing",
                     status: "archived",
                     user: user1)
  end

  it "should allow users to view their private articles", :user1, :priv do
    expect(current_path).to eq(article_path(article_priv))
  end

  it "should not allow other users to view private articles", :user2, :priv do
    expect(current_path).to eq(root_path)
  end

  it "should not allow non-admins to view archived articles", :user1, :arch do
    expect(current_path).to eq(root_path)
  end

  it "should allow admins to view archived articles", :user_adm, :arch do
    expect(current_path).to eq(article_path(article_arch))
  end

  it "should allow admins to view any private articles", :user_adm do
    visit article_path(article_priv)
    expect(current_path).to eq(article_path(article_priv))
  end
end
