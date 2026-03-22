# frozen_string_literal: true

require "spec_helper"

RSpec.describe TaxCalculator do
  subject(:calculator) { TaxCalculator.new(catalog: ItemCatalog.new) }

  describe "#total_tax_for" do
    context "when the item is exempt from basic sales tax" do
      it "applies no tax to books" do
        item = Item.new(name: "book", quantity: 1, unit_price: BigDecimal("12.49"))
        expect(calculator.total_tax_for(item)).to eq(0)
      end

      it "applies no tax to food" do
        item = Item.new(name: "chocolate bar", quantity: 1, unit_price: BigDecimal("0.85"))
        expect(calculator.total_tax_for(item)).to eq(0)
      end

      it "applies no tax to medical products" do
        item = Item.new(name: "headache pills", quantity: 1, unit_price: BigDecimal("9.75"))
        expect(calculator.total_tax_for(item)).to eq(0)
      end
    end

    context "when the item is subject to basic sales tax" do
      it "applies a 10% tax rate" do
        item = Item.new(name: "music CD", quantity: 1, unit_price: BigDecimal("14.99"))
        expect(calculator.total_tax_for(item)).to eq(BigDecimal("1.50"))
      end

      it "rounds the tax amount up to the nearest 0.05" do
        item = Item.new(name: "music CD", quantity: 1, unit_price: BigDecimal("18.99"))
        expect(calculator.total_tax_for(item)).to eq(BigDecimal("1.90"))
      end

      it "multiplies the per-unit tax by quantity" do
        item = Item.new(name: "music CD", quantity: 3, unit_price: BigDecimal("14.99"))
        expect(calculator.total_tax_for(item)).to eq(BigDecimal("4.50"))
      end
    end

    context "when the item is imported" do
      it "applies a 5% import duty even if the item is otherwise exempt" do
        item = Item.new(name: "imported box of chocolates", quantity: 1, unit_price: BigDecimal("10.00"), imported: true)
        expect(calculator.total_tax_for(item)).to eq(BigDecimal("0.50"))
      end

      it "applies both basic tax and import duty for non-exempt imported items" do
        item = Item.new(name: "imported bottle of perfume", quantity: 1, unit_price: BigDecimal("47.50"), imported: true)
        expect(calculator.total_tax_for(item)).to eq(BigDecimal("7.15"))
      end
    end
  end

  describe "#total_price_for" do
    it "returns the unit price when no tax applies" do
      item = Item.new(name: "book", quantity: 1, unit_price: BigDecimal("12.49"))
      expect(calculator.total_price_for(item)).to eq(BigDecimal("12.49"))
    end

    it "adds tax to the unit price" do
      item = Item.new(name: "music CD", quantity: 1, unit_price: BigDecimal("14.99"))
      expect(calculator.total_price_for(item)).to eq(BigDecimal("16.49"))
    end

    it "accounts for quantity" do
      item = Item.new(name: "book", quantity: 2, unit_price: BigDecimal("12.49"))
      expect(calculator.total_price_for(item)).to eq(BigDecimal("24.98"))
    end
  end
end
