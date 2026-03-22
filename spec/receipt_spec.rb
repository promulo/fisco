# frozen_string_literal: true

require "spec_helper"

RSpec.describe Receipt do
  let(:calculator) { TaxCalculator.new(catalog: ItemCatalog.new) }
  let(:parser) { InputParser.new }

  def receipt_for(input)
    items = parser.parse(input)
    Receipt.new(items: items, tax_calculator: calculator)
  end

  context "with a mix of taxable and exempt items" do
    let(:receipt) do
      receipt_for(<<~TEXT)
        2 book at 12.49
        1 music CD at 14.99
        1 chocolate bar at 0.85
      TEXT
    end

    it "calculates the correct sales taxes" do
      expect(receipt.total_sales_tax).to eq(BigDecimal("1.50"))
    end

    it "calculates the correct total" do
      expect(receipt.total_price).to eq(BigDecimal("42.32"))
    end

    it "formats the receipt correctly" do
      expect(receipt.to_s).to eq(<<~TEXT.strip)
        2 book: 24.98
        1 music CD: 16.49
        1 chocolate bar: 0.85
        Sales Taxes: 1.50
        Total: 42.32
      TEXT
    end
  end

  context "with imported items only" do
    let(:receipt) do
      receipt_for(<<~TEXT)
        1 imported box of chocolates at 10.00
        1 imported bottle of perfume at 47.50
      TEXT
    end

    it "calculates the correct sales taxes" do
      expect(receipt.total_sales_tax).to eq(BigDecimal("7.65"))
    end

    it "calculates the correct total" do
      expect(receipt.total_price).to eq(BigDecimal("65.15"))
    end

    it "formats the receipt correctly" do
      expect(receipt.to_s).to eq(<<~TEXT.strip)
        1 imported box of chocolates: 10.50
        1 imported bottle of perfume: 54.65
        Sales Taxes: 7.65
        Total: 65.15
      TEXT
    end
  end

  context "with a mix of imported and domestic items" do
    let(:receipt) do
      receipt_for(<<~TEXT)
        1 imported bottle of perfume at 27.99
        1 bottle of perfume at 18.99
        1 packet of headache pills at 9.75
        3 imported boxes of chocolates at 11.25
      TEXT
    end

    it "calculates the correct sales taxes" do
      expect(receipt.total_sales_tax).to eq(BigDecimal("7.90"))
    end

    it "calculates the correct total" do
      expect(receipt.total_price).to eq(BigDecimal("98.38"))
    end

    it "formats the receipt correctly" do
      expect(receipt.to_s).to eq(<<~TEXT.strip)
        1 imported bottle of perfume: 32.19
        1 bottle of perfume: 20.89
        1 packet of headache pills: 9.75
        3 imported boxes of chocolates: 35.55
        Sales Taxes: 7.90
        Total: 98.38
      TEXT
    end
  end
end
