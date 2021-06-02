require_relative './contract'
require_relative './claim'
require 'date'

# Adjudicate/adjudication - a judgment made on a claim to determine whether
# we are legally obligated to process the claim against the warranty. From
# Wikipedia (https://en.wikipedia.org/wiki/Adjudication):
#
#  "Claims adjudication" is a phrase used in the insurance industry to refer to
#  the process of paying claims submitted or denying them after comparing claims
#  to the benefit or coverage requirements.

class ClaimsAdjudication
  def adjudicate(contract, new_claim)
    if limit_of_liability(contract) > new_claim.amount &&
      new_claim.date  >= contract.effective_date &&
      new_claim.date  <= contract.expiration_date &&
      contract.status == "ACTIVE"
      contract.claims << new_claim
    end
  end

  # We should move this to the contract class
  # Should the limit of liability be calculated pre-claim
  # Magic number = 0.8 - 80%? of the contract purchase price? covered product purchase price?
  # contract lifecycle - dates and status
  def limit_of_liability(contract)
    claim_total = 0.0
    contract.claims.each { |claim|
      claim_total += claim.amount
    }
    (contract.purchase_price - claim_total) * 0.8
  end
end
