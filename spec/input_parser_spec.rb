# frozen_string_literal: true

require "spec_helper"

RSpec.describe InputParser do
  subject(:parser) { InputParser.new }

  describe "#parse" do
    it "parses a single line into an item" do
      items = parser.parse("1 music CD at 14.99")
      expect(items.length).to eq(1)
    end

    it "extracts the quantity, name, and price" do
      item = parser.parse("1 music CD at 14.99").first
      expect(item.quantity).to eq(1)
      expect(item.name).to eq("music CD")
      expect(item.unit_price).to eq(BigDecimal("14.99"))
    end

    it "parses multiple lines into multiple items" do
      input = <<~TEXT
        2 book at 12.49
        1 music CD at 14.99
        1 chocolate bar at 0.85
      TEXT
      expect(parser.parse(input).length).to eq(3)
    end

    it "ignores blank lines" do
      items = parser.parse("\n1 book at 12.49\n\n")
      expect(items.length).to eq(1)
    end

    it "marks items with 'imported' in the name as imported" do
      item = parser.parse("1 imported bottle of perfume at 47.50").first
      expect(item.imported?).to be true
    end

    it "treats items without 'imported' in the name as domestic" do
      item = parser.parse("1 bottle of perfume at 18.99").first
      expect(item.imported?).to be false
    end

    it "raises an error for lines that do not match the expected format" do
      expect { parser.parse("one book") }.to raise_error(ArgumentError, /Invalid input format/)
    end
  end
end
