# frozen_string_literal: true

admin = User.create(email: "dunn2000@mail.ru",
                    password: "Foobar",
                    admin: true)
status = %w[public private archived]
10.times do
  article = Article.create!(title: Faker::Book.title,
                            body: Faker::Lorem.sentence(word_count: 30),
                            user: admin, status: status.sample)
  Comment.create!(body: Faker::Lorem.sentence(word_count: 10),
                  article: article, status: "archived", user: admin)
  Comment.create!(body: Faker::Lorem.sentence(word_count: 10),
                  article: article, status: "private", user: admin)
  Comment.create!(body: Faker::Lorem.sentence(word_count: 10),
                  article: article, status: "public", user: admin)
end

40.times do |n|
  email = "test-#{n + 1}@s.com"
  password = "password"
  User.create!(email: email, password: password)
end

30.times do |n|
  article = Article.create!(title: Faker::Book.title,
                            body: Faker::Lorem.sentence(word_count: 30),
                            user: User.find(n + 2), status: "public")
  Comment.create!(body: Faker::Lorem.sentence(word_count: 10),
                  article: article, status: "archived", user: User.find(n + 2))
  Comment.create!(body: Faker::Lorem.sentence(word_count: 10),
                  article: article, status: "private", user: User.find(n + 2))
  Comment.create!(body: Faker::Lorem.sentence(word_count: 10),
                  article: article, status: "public", user: User.find(n + 2))
end
