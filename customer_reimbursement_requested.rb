require 'date'

class CustomerReimbursementRequested
  attr_reader   :occurred_on
  attr_reader   :contract_id
  attr_reader   :representative_name
  attr_reader   :reason

  def initialize(contract_id, representative_name, reason)
    @occurred_on          = Date.today
    @contract_id          = contract_id
    @representative_name  = representative_name
    @reason               = reason
  end
end
