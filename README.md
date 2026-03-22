# Fisco

A receipt printer that applies sales tax and import duties to a list of purchased items.

## Running

```
ruby bin/receipt.rb data/input1.txt
```

Three sample inputs are included in `data/`.

## Tests

```
bundle install
bundle exec rspec
```

## Design

```
Input file
    │
    ▼
InputParser ──► Item
                  │
                  ▼
            TaxCalculator ◄── ItemCatalog
                  │
                  ▼
               Receipt ──► formatted output
```

- `InputParser` — parses raw text lines into `Item` objects
- `ItemCatalog` — knows which products are tax-exempt (keyword matching)
- `TaxCalculator` — applies rates, rounds up to nearest 0.05. Receives `ItemCatalog` as a dependency.
- `Item` — immutable value object (frozen after creation)
- `Receipt` — aggregates items, computes totals, formats output via `to_s`

All monetary values use `BigDecimal` to avoid floating point errors. Tax is rounded per unit before multiplying by quantity.

Objects are either frozen or created per-request, with no shared mutable state — making the code thread-safe without needing locks.

## Assumptions

- Input follows `<quantity> <name> at <price>` — anything else raises an error.
- "imported" in the name means the item is imported.
- Prices always have two decimal places.
- The exempt keyword list only covers products in the provided test cases.

## Next steps

- Replace keyword matching with an explicit product catalog (YAML, database) to handle ambiguous names reliably
- Extract receipt formatting from `Receipt#to_s` if multiple output formats are needed (JSON, HTML, etc.)
- Move tax rates and exemption rules to configuration to support multiple jurisdictions without code changes
