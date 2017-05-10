require_relative './spec_helper'
require_relative '../quantity.rb'

describe Quantity do
  it "compares quantity values" do
    expect(100.teaspoon).to eq(100.teaspoon)
    expect(100.teaspoon).not_to eq(100.ounce)
    expect(100.teaspoon).not_to eq(nil)
    expect(100.teaspoon).not_to eq('String')

    expect(1.inch).to eq(1.inch)
    expect(1.inch).not_to eq(1.foot)
    expect(1.inch).not_to eq(1.teaspoon)
    expect(12.inch).not_to eq(nil)
    expect(100.inch).not_to eq('String')
  end

  it "compares hashes" do
    expect(100.teaspoon.hash).to eq(100.teaspoon.hash)
    expect(3.teaspoon.hash).to eq(1.tablespoon.hash)

    expect(1.inch.hash).to eq(1.inch.hash)
    expect(12.inch.hash).to eq(1.foot.hash)

    expect(1.inch.hash).not_to eq(1.teaspoon.hash)
    expect(1.celsius.hash).to eq(1.celsius.hash)
    expect(0.celsius.hash).to eq(32.fahrenheit.hash)
    expect(1.celsius.hash).not_to eq(1.fahrenheit.hash)
  end

  it "converts quantities" do
    expect(3.teaspoon).to eq(1.tablespoon)
    expect(2.tablespoon).to eq(1.ounce)
    expect(8.ounce).to eq(1.cup)
    expect(2.cup).to eq(1.pint)
    expect(2.pint).to eq(1.quart)
    expect(4.quart).to eq(1.gallon)
    expect(1.tablespoon).to eq(3.teaspoon)
    expect(1.ounce).to eq(2.tablespoon)
    expect(1.cup).to eq(8.ounce)
    expect(1.pint).to eq(2.cup)
    expect(1.quart).to eq(2.pint)
    expect(1.gallon).to eq(4.quart)
    expect(3.teaspoon).not_to eq(1.cup)
    expect(2.tablespoon).not_to eq(1.gallon)
    expect(8.ounce).not_to eq(1.pint)
    expect(2.cup).not_to eq(1.teaspoon)
    expect(2.pint).not_to eq(1.ounce)
    expect(4.quart).not_to eq(1.cup)

    expect(12.inch).to eq(1.foot)
  end

  it do
    expect(1.teaspoon).to be < 2.teaspoon
    expect(1.teaspoon).to be < 2.cup
    expect(1.gallon).to be > 2.teaspoon
    expect(3.quart).to be > 2.cup
  end

  it do
    expect(3.tablespoon).to eq((1.tablespoon + 2.tablespoon))
    expect(3.tablespoon).to eq((3.teaspoon + 2.tablespoon))
    expect(3.cup).to eq((0.cup + 3.cup))
    expect(2.gallon).to eq((4.quart + 4.pint + 384.teaspoon))
  end

  it do
    expect(-1.tablespoon).to eq((2.tablespoon - 3.tablespoon))
    expect(1.tablespoon).to eq((3.tablespoon - 2.tablespoon))
  end

  it "handles temparatures" do
    expect(0.celsius).to eq(0.celsius)
    expect(23.5.celsius).to eq(23.5.celsius)
    expect(0.celsius).to eq(32.fahrenheit)
    expect(107.6.fahrenheit).to eq(42.celsius)
    expect(42.fahrenheit).to eq(5.55556.celsius)
    expect(0.fahrenheit).not_to eq(0.celsius)
    expect(-40.celsius).to eq(-40.fahrenheit)
  end

  it 'does not support pointless arithmetics' do
    expect(1.celsius.methods).not_to include(:+)
    expect(1.fahrenheit.methods).not_to include(:-)
    expect { 42.fahrenheit + 0.celsius }.to raise_error(NoMethodError)
    expect { 42.celsius - 50.fahrenheit }.to raise_error(NoMethodError)
  end
end
