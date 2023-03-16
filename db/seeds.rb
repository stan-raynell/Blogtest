# frozen_string_literal: true

admin = User.create(email: "dunn2000@mail.ru",
                    password: "Foobar",
                    admin: true)
status = %w[public private archived]
comm_params = { body: Faker::Lorem.sentence(word_count: 10), user: admin }
10.times do
  article = Article.create!(title: Faker::Book.title,
                            body: Faker::Lorem.sentence(word_count: 30),
                            user: admin, status: status.sample)
  Comment.create!(comm_params.merge(article:, status: "public"))
  Comment.create!(comm_params.merge(article:, status: "private"))
  Comment.create!(comm_params.merge(article:, status: "archived"))
end

40.times do |n|
  email = "test-#{n + 1}@s.com"
  password = "password"
  User.create!(email: email, password: password)
end
comm_params2 = { body: Faker::Lorem.sentence(word_count: 10), user: User.find(n + 2) }
30.times do |n|
  article = Article.create!(title: Faker::Book.title,
                            body: Faker::Lorem.sentence(word_count: 30),
                            user: User.find(n + 2), status: "public")
  Comment.create!(comm_params2.merge(article:, status: "archived"))
  Comment.create!(comm_params2.merge(article:, status: "archived"))
  Comment.create!(comm_params2.merge(article:, status: "archived"))
end
