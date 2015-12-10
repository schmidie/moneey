require 'minitest/autorun'
require 'moneey'

# Unit-Tests for the Moneey Class

class TestMoneey < MiniTest::Unit::TestCase

  def setup
    @usd_rate = 1.11
    @bitcoin_rate = 0.0047
    Moneey.conversion_rates('EUR', {
      'USD'     => @usd_rate,
      'Bitcoin' => @bitcoin_rate
    })

    @fifty_eur = Moneey.new(50, 'EUR')
    @twenty_usd = Moneey.new(20, 'USD')
    @seventy_bitcoins = Moneey.new(70, 'Bitcoin')
  end

  #convertion

  def test_convertion_from_eur_to_usd
    assert_equal @fifty_eur.convert_to('USD'), Moneey.new(50*@usd_rate, 'USD')
  end
  def test_convertion_from_eur_to_bitcoin
    assert_equal @fifty_eur.convert_to('Bitcoin'), Moneey.new(50*@bitcoin_rate, 'Bitcoin')
  end
  def test_that_doubleconvertion_result_original_amount_eur
    # 50EUR == 50EUR in USD in EUR
    assert_equal @fifty_eur.amount, @fifty_eur.convert_to('USD').convert_to('EUR').amount
  end
  def test_that_doubleconvertion_result_original_amount_bitcoin
    # 70Bitcoins == 70Bitcoins in USD in Bitcoins
    # this we need to round to the cents, else it wont work
    # notice: in the comparison-method we also round on the cents
    assert_equal @seventy_bitcoins.amount, @seventy_bitcoins.convert_to('USD').convert_to('Bitcoin').amount.round(2)
  end
  def test_that_doubleconvertion_result_original_amount_usd
    # 20 USD == 20 USD in EUR in USD
    assert_equal @twenty_usd.amount, @twenty_usd.convert_to('EUR').convert_to('USD').amount
  end

  # arithmetic functions

  def test_addition_with_different_currencies
    # 50EUR + 50EUR in USD == 100EUR
    assert_equal (@fifty_eur + @fifty_eur.convert_to('USD')), Moneey.new(100, 'EUR')
  end
  def test_substraction_with_negative_result
    # 50EUR - (50EUR in Bitcoins + 50EUR in USD) == -50EUR
    assert_equal (@fifty_eur - (@fifty_eur.convert_to('Bitcoin')+@fifty_eur.convert_to('USD'))), Moneey.new(-50, 'EUR')
  end
  def test_substraction_with_different_currencies
    # 50EUR - 50EUR in USD == 0EUR
    assert_equal (@fifty_eur - @fifty_eur.convert_to('USD')), Moneey.new(0, 'EUR')
  end
  def test_multiplication
    # 50EUR * 2 == 100EUR
    assert_equal @fifty_eur*2, Moneey.new(100, 'EUR')
  end
  def test_divide
    # 50EUR / 2 == 25EUR
    assert_equal @fifty_eur/2, Moneey.new(25, 'EUR')
  end
  def test_divide_with_convertion
    # 50EUR / 2 == 25EUR in Bitcoins
    assert_equal @fifty_eur/2, Moneey.new(25, 'EUR').convert_to('Bitcoin')
  end

  def test_divide_with_wrong_convertion
    # 50EUR / 2 == 25EUR in Bla
    # we do not have configuration rate 'Bla'. So this convertion shouldn't do anything
    assert_equal @fifty_eur/2, Moneey.new(25, 'EUR').convert_to('Bla')
  end

  # comparison

  def test_equal_comparison_with_convertion
      # 70bitcoins == 70bitcoins in USD in Bitcoins
      assert_operator @seventy_bitcoins, :== ,@seventy_bitcoins.convert_to('USD').convert_to('Bitcoin')
  end
  def test_bigger_than_comparison_with_convertion
      # 70bitcoins + 70bitcoins > 70bitcoins in USD
      assert_operator (@seventy_bitcoins + @seventy_bitcoins ), :> ,@seventy_bitcoins.convert_to('USD')
  end
  def test_smaller_than_comparison_with_convertion
      # 70bitcoins - 70bitcoins in EUR < 70bitcoins in USD
      assert_operator @seventy_bitcoins - @seventy_bitcoins.convert_to('EUR'), :< ,@seventy_bitcoins.convert_to('USD')
  end
  def test_bigger_or_equal_than_comparison_with_convertion
      tmp_m = Moneey.new(1, 'USD')
      # 70bitcoins + 1USD >= 70bitcoins in USD + 1USD
      assert_operator @seventy_bitcoins + tmp_m, :>= ,@seventy_bitcoins.convert_to('USD') + tmp_m
  end

  # Output

  def test_that_seventy_bitcoins_outputs_70
    assert_equal @seventy_bitcoins.inspect, "70.00 Bitcoin"
  end

end
