class QbWorker::QbCompany
  attr_accessor :qb_entity, :qb_action
  def initialize
    @qb_action = nil unless @qb_action
    @qb_entity = self
    @t2_entity = Company
  end
  
end