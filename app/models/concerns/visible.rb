# frozen_string_literal: true

module Visible
  extend ActiveSupport::Concern

  VALID_STATUSES = %w[public private archived].freeze

  included do
    validates :status, inclusion: { in: VALID_STATUSES }
  end

  class_methods do
    def public_count
      where(status: "public").count
    end
  end

  %i[archived? public? private?].each do |name|
    define_method name do
      status == name.to_s.chop
    end
  end
end
