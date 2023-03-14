require "rails_helper"

RSpec.describe Comment, type: :model do
  let!(:user1) { create(:user) }
  let!(:article1) do
    create(:article, title: "Yay!", body: "Go Rails and GTFO!",
                     status: "public",
                     user: user1)
  end
  let!(:bad_comment) do
    build(:comment, user: user1, body: "", article: article1, status: "public")
  end

  it "should not allow to save empty comments" do
    expect(bad_comment.save).to be_falsy
  end
end
