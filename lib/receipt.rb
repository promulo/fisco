# frozen_string_literal: true

# Builds a receipt from a list of items using a tax calculator.
# Computes per-item totals, total sales tax, and grand total.
# Formats the receipt as a human-readable string via #to_s.
class Receipt
  def initialize(items:, tax_calculator:)
    @items = items
    @tax_calculator = tax_calculator
  end

  def total_sales_tax
    @total_sales_tax ||= @items.sum { |item| @tax_calculator.total_tax_for(item) }
  end

  def total_price
    @total_price ||= @items.sum { |item| @tax_calculator.total_price_for(item) }
  end

  def to_s
    lines = @items.map { |item| format_item(item) }
    lines << format("Sales Taxes: %.2f", total_sales_tax)
    lines << format("Total: %.2f", total_price)
    lines.join("\n")
  end

  private

  def format_item(item)
    price_with_tax = @tax_calculator.total_price_for(item)
    format("%d %s: %.2f", item.quantity, item.name, price_with_tax)
  end
end
