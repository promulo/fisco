#!/usr/bin/env ruby
# frozen_string_literal: true

Dir[File.join(__dir__, "../lib/*.rb")].each { |f| require f }

if ARGV.empty? || !File.exist?(ARGV[0])
  warn "Usage: ruby bin/receipt.rb <input_file>"
  warn "Example: ruby bin/receipt.rb data/input1.txt"
  exit 1
end

input = File.read(ARGV[0])

parser = InputParser.new
catalog = ItemCatalog.new
calculator = TaxCalculator.new(catalog: catalog)

items = parser.parse(input)
receipt = Receipt.new(items: items, tax_calculator: calculator)

puts receipt
