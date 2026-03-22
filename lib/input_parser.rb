# frozen_string_literal: true

require "bigdecimal"
require_relative "item"

# Parses raw text input into Item objects.
#
# Expected input format per line:
#   <quantity> <name> at <price>
#
# Examples:
#   "2 book at 12.49"
#   "1 imported bottle of perfume at 47.50"
#   "3 imported boxes of chocolates at 11.25"
class InputParser
  LINE_PATTERN = /\A(\d+)\s+(.+)\s+at\s+(\d+\.\d{2})\z/

  def parse(text)
    text.each_line.filter_map do |line|
      line = line.strip
      next if line.empty?

      parse_line(line)
    end
  end

  private

  def parse_line(line)
    match = LINE_PATTERN.match(line)
    raise ArgumentError, "Invalid input format: '#{line}'" unless match

    quantity = match[1].to_i
    name = match[2].strip
    price = BigDecimal(match[3])
    imported = name.downcase.include?("imported")

    Item.new(name: name, quantity: quantity, unit_price: price, imported: imported)
  end
end
