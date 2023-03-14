# frozen_string_literal: true

class Comment < ApplicationRecord
  include Visible

  belongs_to :article
  belongs_to :user

  validates :body, presence: true
end
