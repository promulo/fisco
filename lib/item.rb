# frozen_string_literal: true

# Represents a purchased item with its pricing and tax details.
# Immutable value object — once created, its state cannot be modified.
class Item
  attr_reader :name, :quantity, :unit_price

  def initialize(name:, quantity:, unit_price:, imported: false)
    @name = name.freeze
    @quantity = quantity
    @unit_price = unit_price
    @imported = imported
    freeze
  end

  def imported?
    @imported
  end
end
