# frozen_string_literal: true

require "bigdecimal"

# Calculates sales tax for an item based on its category and import status.
#
# Tax rules:
#   - Basic sales tax: 10% on all goods except books, food, and medical products
#   - Import duty: 5% on all imported goods (no exemptions)
#   - Rounding: tax is rounded up to the nearest 0.05
#
# Depends on ItemCatalog to determine exemption status.
class TaxCalculator
  BASIC_TAX_RATE = BigDecimal("0.10")
  IMPORT_DUTY_RATE = BigDecimal("0.05")
  ROUNDING_STEP = BigDecimal("0.05")

  def initialize(catalog:)
    @catalog = catalog
  end

  # Returns the total tax amount for all units of the item.
  def total_tax_for(item)
    tax_for(item) * item.quantity
  end

  # Returns the total price for all units including tax.
  def total_price_for(item)
    (item.unit_price + tax_for(item)) * item.quantity
  end

  private

  def tax_for(item)
    rate = applicable_rate(item)
    round_tax(item.unit_price * rate)
  end

  def applicable_rate(item)
    rate = BigDecimal("0")
    rate += BASIC_TAX_RATE unless @catalog.exempt?(item.name)
    rate += IMPORT_DUTY_RATE if item.imported?
    rate
  end

  # Rounds a tax amount up to the nearest 0.05.
  # e.g., 1.499 becomes 1.50, 2.41 becomes 2.45
  def round_tax(amount)
    (amount / ROUNDING_STEP).ceil * ROUNDING_STEP
  end
end
