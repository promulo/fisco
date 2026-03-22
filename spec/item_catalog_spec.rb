# frozen_string_literal: true

require "spec_helper"

RSpec.describe ItemCatalog do
  subject(:catalog) { ItemCatalog.new }

  describe "#exempt?" do
    context "with books" do
      it { expect(catalog.exempt?("book")).to be true }
    end

    context "with food" do
      it { expect(catalog.exempt?("chocolate bar")).to be true }
      it { expect(catalog.exempt?("box of chocolates")).to be true }
      it { expect(catalog.exempt?("candy")).to be true }
    end

    context "with medical products" do
      it { expect(catalog.exempt?("headache pills")).to be true }
      it { expect(catalog.exempt?("packet of tablet")).to be true }
    end

    context "with other goods" do
      it { expect(catalog.exempt?("music CD")).to be false }
      it { expect(catalog.exempt?("bottle of perfume")).to be false }
    end
  end
end
