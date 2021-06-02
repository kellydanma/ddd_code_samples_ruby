require "test/unit"
require 'date'
require_relative './claims_adjudication'
require_relative './terms_and_conditions'

class ClaimsAdjudicationTest < Test::Unit::TestCase
  def test_claims_adjudication_for_valid_claim
    contract = fake_contract
    claim = Claim.new(79.0, Date.new(2010, 5, 8))

    claims_adjudication = ClaimsAdjudication.new
    claims_adjudication.adjudicate(contract, claim)

    assert_equal 1, contract.claims.length
    assert_equal 79.0, contract.claims.first.amount
    assert_equal Date.new(2010, 5, 8), contract.claims.first.date
  end

  def test_claims_adjudication_for_multiple_claims
    contract = fake_contract
    claim_1 = Claim.new(29.0, Date.new(2010, 5, 8))
    contract.claims << claim_1

    claim_2 = Claim.new(50.0, Date.new(2010, 7, 9))
    claims_adjudication = ClaimsAdjudication.new
    claims_adjudication.adjudicate(contract, claim_2)

    assert_equal 2, contract.claims.length
    assert_equal 29.0, contract.claims.first.amount
    assert_equal Date.new(2010, 5, 8), contract.claims.first.date
    assert_equal 50.0, contract.claims[1].amount
    assert_equal Date.new(2010, 7, 9), contract.claims[1].date
  end

  def test_claims_adjudication_for_invalid_claim_amount
    contract = fake_contract
    claim = Claim.new(81.0, Date.new(2010, 5, 8))

    claims_adjudication = ClaimsAdjudication.new
    claims_adjudication.adjudicate(contract, claim)

    assert_equal 0, contract.claims.length
  end

  def test_claims_adjudication_for_pending_contract
    contract = fake_contract
    contract.status = "PENDING"
    claim = Claim.new(79.0, Date.new(2010, 5, 8))

    claims_adjudication = ClaimsAdjudication.new
    claims_adjudication.adjudicate(contract, claim)

    assert_equal 0, contract.claims.length
  end

  def test_claims_adjudication_for_contract_prior_to_effective_date
    contract = fake_contract
    claim = Claim.new(79.0, Date.new(2010, 5, 5))

    claims_adjudication = ClaimsAdjudication.new
    claims_adjudication.adjudicate(contract, claim)

    assert_equal 0, contract.claims.length
  end

  def test_claims_adjudication_for_expired_contract
    contract = fake_contract
    contract.status          = "EXPIRED"

    claim = Claim.new(79.0, Date.new(2010, 5, 8))

    claims_adjudication = ClaimsAdjudication.new
    claims_adjudication.adjudicate(contract, claim)

    assert_equal 0, contract.claims.length
  end

  def test_claims_adjudication_for_contract_after_expiration_date
    contract = fake_contract
    claim = Claim.new(79.0, Date.new(2012, 5, 9))

    claims_adjudication = ClaimsAdjudication.new
    claims_adjudication.adjudicate(contract, claim)

    assert_equal 0, contract.claims.length
  end

  private

  def fake_contract
    terms_and_conditions = TermsAndConditions.new(
      Date.new(2010, 5, 8),
      Date.new(2012, 5, 8),
      Date.new(2009, 12, 25),
      30
    )

    product  = Product.new("dishwasher", "OEUOEU23", "Whirlpool", "7DP840CWDB0")
    contract = Contract.new(100.0, product, terms_and_conditions)

    contract.status          = "ACTIVE"

    contract
  end
end
