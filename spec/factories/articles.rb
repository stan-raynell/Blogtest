# frozen_string_literal: true

FactoryBot.define do
  factory :article do
    title { "Goo" }
    body { "This is test body" }
    user_id {}
  end
end
