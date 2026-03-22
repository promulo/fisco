# frozen_string_literal: true

# Knows about product categories and their tax exemption status.
# An item is exempt from basic sales tax if it falls under
# books, food, or medical products.
class ItemCatalog
  EXEMPT_KEYWORDS = %w[
    book
    chocolate
    pill
    tablet
    food
    candy
  ].freeze

  def exempt?(item_name)
    EXEMPT_KEYWORDS.any? { |keyword| item_name.downcase.include?(keyword) }
  end
end
