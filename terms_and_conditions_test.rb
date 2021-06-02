require "test/unit"
require 'date'
require_relative './terms_and_conditions'

class TermsAndConditionsTest < Test::Unit::TestCase
  def test_equality
    effective_date = Date.new(2010, 5, 8),
    expiration_date = Date.new(2012, 5, 8),
    purchase_date = Date.new(2009, 12, 25),
    in_store_guarantee_days = 30

    terms_and_conditions_1 = TermsAndConditions.new(
      effective_date, 
      expiration_date,
      purchase_date,
      in_store_guarantee_days
    )

    terms_and_conditions_2 = TermsAndConditions.new(
      effective_date, 
      expiration_date,
      purchase_date,
      in_store_guarantee_days
    )

    assert_equal terms_and_conditions_1, terms_and_conditions_2
  end

  def test_inequality
    effective_date = Date.new(2010, 5, 8),
    expiration_date = Date.new(2012, 5, 8),
    purchase_date = Date.new(2009, 12, 25),
    in_store_guarantee_days = 30

    terms_and_conditions_1 = TermsAndConditions.new(
      effective_date, 
      expiration_date,
      purchase_date,
      in_store_guarantee_days
    )

    terms_and_conditions_2 = TermsAndConditions.new(
      effective_date, 
      expiration_date,
      purchase_date,
      in_store_guarantee_days - 10
    )

    refute_equal terms_and_conditions_1, terms_and_conditions_2
  end
end
