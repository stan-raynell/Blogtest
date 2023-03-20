# frozen_string_literal: true

module UsersHelper
  # A self-explanatory module for avatars.

  def gravatar_for(user, options = { size: 150 })
    size = options[:size]
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.email, class: "gravatar")
  end
end
