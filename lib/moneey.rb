#!/usr/bin/ruby

# Moneey Class
# * convertion between different currencies
# * arithmetic operations +-*/
# * Comparisons < > >= <= == !=
#
# Set Convertion-Rates with:
#   Moneey.conversion_rates(Base-Currency, {
#     Currency1 => convertion_rate1,
#     Currency2 => convertion_rate2
#   })

class Moneey
  include Comparable
  attr_accessor :amount, :currency

  # global convertion_rates configuration
  # should look something like this:
  # {'EUR' => 1.0, 'USD' => 1.11,'Bitcoin' => 0.0047}
  @@c_rates_config = Hash.new

  def initialize(amount, currency)
      @amount = amount
      @currency = currency
  end

  def self.conversion_rates(base_currency, convertion_rates)
    # We can set the base to 1.0
    @@c_rates_config = convertion_rates.merge(base_currency => 1.0)
  end

  def convert_to(currency)
    # If there is no conviguration rate for currency,we do not do anything.
    money = self
    if @@c_rates_config.has_key?(self.currency) && @@c_rates_config.has_key?(currency)
      to_rate = @@c_rates_config[currency]
      from_rate = @@c_rates_config[self.currency]
      # Convert to new currency with to_rate
      # example: ( 50USD / 1.11 ) * 0.0047 = 0,21... Bitcoins
      # note: we do not round here.
      new_amount = (self.amount/from_rate) * to_rate
      money = Moneey.new(new_amount, currency)
    end
    money
  end

  # for calculation and comparison we convert to same currency
  def convert_to_same_currency(money)
    if self.currency != money.currency
      money = money.convert_to(self.currency)
    end
    money
  end

  # define the spaceship-method, so we have all comparison at one go!
  # note: we have to include Comparable
  def <=>(money)
    # convert the money object to same curency than self
    money = convert_to_same_currency(money)
    # for comparison we need to round
    self_amount = self.amount.round(2)
    money_amount = money.amount.round(2)
    if self_amount < money_amount
      -1
    elsif self_amount > money_amount
      1
    else
      0
    end
  end

  # Override the arithmetic operations for Money Objects
  def +(money)
    money = self.convert_to_same_currency(money)
    Moneey.new(self.amount + money.amount, self.currency)
  end
  def -(money)
    money = self.convert_to_same_currency(money)
    Moneey.new(self.amount - money.amount, self.currency)
  end
  def *(digit)
    Moneey.new(self.amount * digit, self.currency)
  end
  def /(digit)
    Moneey.new(self.amount / digit, self.currency)
  end

  def inspect
      "#{format("%.2f", self.amount)} #{self.currency}"
  end

end
