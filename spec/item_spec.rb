# frozen_string_literal: true

require "spec_helper"

RSpec.describe Item do
  subject(:item) { Item.new(name: "music CD", quantity: 1, unit_price: BigDecimal("14.99")) }

  it "exposes its attributes" do
    expect(item.name).to eq("music CD")
    expect(item.quantity).to eq(1)
    expect(item.unit_price).to eq(BigDecimal("14.99"))
  end

  it "is not imported by default" do
    expect(item.imported?).to be false
  end

  it "can be marked as imported" do
    imported_item = Item.new(name: "imported bottle of perfume", quantity: 1, unit_price: BigDecimal("47.50"), imported: true)
    expect(imported_item.imported?).to be true
  end

  it "is immutable" do
    expect(item).to be_frozen
  end
end
