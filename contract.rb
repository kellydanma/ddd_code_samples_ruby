require 'securerandom'
require 'pry'

require_relative './product'

class Contract
  # Magic number = 0.8 - 80%? of the contract purchase price? covered product purchase price?
  # contract lifecycle - dates and status; We're not sure what it is yet.
  CONTRACT_PURCHASE_PERCENTAGE = 0.8

  attr_reader   :id # unique id
  attr_reader   :purchase_price
  attr_reader   :covered_product

  attr_accessor :status # We don't know when the status should be set. What does it represent?
                        # What other statuses are available?
  attr_accessor :effective_date
  attr_accessor :expiration_date
  attr_accessor :purchase_date
  attr_accessor :in_store_guarantee_days

  attr_accessor :claims

  def initialize(purchase_price, covered_product)
    @id                 = SecureRandom.uuid
    @purchase_price     = purchase_price
    @status             = "PENDING"
    @covered_product    = covered_product
    @claims             = Array.new
  end

  # Equality for entities is based on unique id
  def ==(other)
    self.id == other.id
  end

  def limit_of_liability
    claim_total = claims.inject(0){ |total, claim| total + claim.amount }
    (purchase_price - claim_total) * CONTRACT_PURCHASE_PERCENTAGE
  end

  def valid_for?(date)
    date >= effective_date && date <= expiration_date
  end
end
