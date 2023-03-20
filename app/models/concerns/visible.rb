# frozen_string_literal: true

module Visible
  extend ActiveSupport::Concern

  # This module defines comments and articles statuses.

  VALID_STATUSES = %w[public private archived].freeze

  included do
    validates :status, inclusion: { in: VALID_STATUSES }
  end

  class_methods do
    # This method counts the number of "public" articles.

    def public_count
      where(status: "public").count
    end
  end

  %i[archived? public? private?].each do |name|
    define_method name do
      # This method creates boolean question mark methods for statuses.
      status == name.to_s.chop
    end
  end
end
