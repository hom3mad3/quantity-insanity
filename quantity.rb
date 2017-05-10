# It understands a specific measurement
module Quantity
  class IntervalQuantity
    include Comparable

    attr_reader :amount, :unit
    protected :amount, :unit

    def initialize(amount, unit)
      @amount = amount
      @unit = unit
    end

    def <=>(other)
      return unless other.class == self.class
      return unless other.unit.comparable_to?(unit)
      self.amount.to_f.round(2) <=> self.unit.convert_amount(other.amount, other.unit).to_f.round(2)
    end

    def hash
      unit.hash_amount(self.amount)
    end

    private_class_method :new
  end

  class RatioQuantity < IntervalQuantity
    def +(other)
      instantiate(self.amount + self.unit.convert_amount(other.amount, other.unit))
    end

    def -(other)
      self + -other
    end

    def -@
      instantiate(-self.amount)
    end

    private

    def instantiate(amount)
      self.class.send(:new, amount, self.unit)
    end
  end

  # It understands a specific metric
  class Unit
    def create_constructor(name, unit)
      Numeric.class_eval do
        define_method name do
          unit.quantity_class.send(:new, self, unit)
        end
      end
    end

    def comparable_to?(other)
      other.is_a?(self.class)
    end

    class PlainOldUnit < Unit
      attr_reader :base_unit_ratio
      protected :base_unit_ratio

      def initialize(name, relative_amount = 1.0, relative_unit)
        @relative_unit = relative_unit
        @base_unit_ratio = relative_amount * relative_unit.base_unit_ratio
        create_constructor(name, self)
      end

      def quantity_class
        RatioQuantity
      end

      def convert_amount(other_amount, other_unit)
        other_amount * (other_unit.base_unit_ratio / self.base_unit_ratio)
      end

      def comparable_to?(other)
        super && other.base_unit == base_unit
      end

      def hash_amount(amount)
        (amount * base_unit_ratio).hash * base_unit.hash
      end

      protected

      def base_unit
        @relative_unit.base_unit
      end
    end

    class TemperatureUnit < Unit
      attr_reader :name
      protected :name

      def initialize(name)
        @name = name
        create_constructor(name, self)
      end

      def quantity_class
        IntervalQuantity
      end

      def convert_amount(other_amount, other_unit)
        return other_amount if other_unit == self
        send :"convert_from_#{other_unit.name}_to_#{name}", other_amount
      end

      def hash_amount(amount)
        amount_in_celsius(amount).to_f.hash
      end

      private

      def convert_from_fahrenheit_to_celsius(amount)
        (amount - 32) * 5.0 / 9
      end

      def convert_from_celsius_to_fahrenheit(amount)
        amount * 9.0 / 5 + 32
      end

      def amount_in_celsius(amount)
        return amount if name == :celsius
        convert_from_fahrenheit_to_celsius(amount)
      end
    end

    class BaseUnit
      def base_unit_ratio
        42
      end

      def base_unit
        self
      end
    end

    #Plain'ol Unit
    teaspoon = PlainOldUnit.new(:teaspoon, BaseUnit.new)
    tablespoon = PlainOldUnit.new(:tablespoon, 3, teaspoon)
    ounce = PlainOldUnit.new(:ounce, 2, tablespoon)
    cup = PlainOldUnit.new(:cup, 8, ounce)
    pint = PlainOldUnit.new(:pint, 2, cup)
    quart = PlainOldUnit.new(:quart, 2, pint)
    gallon = PlainOldUnit.new(:gallon, 4, quart)

    inch = PlainOldUnit.new(:inch, BaseUnit.new)
    foot = PlainOldUnit.new(:foot, 12, inch)
    yard = PlainOldUnit.new(:yard, 3, foot)
    furlough = PlainOldUnit.new(:furlough, 220, yard)
    mile = PlainOldUnit.new(:mile, 8, furlough)

    #Temperature
    celsius = TemperatureUnit.new(:celsius)
    fahrenheit = TemperatureUnit.new(:fahrenheit)
  end

  private_constant :Unit
end
