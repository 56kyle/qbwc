class QbWorker < QBWC::Worker
  @qb_entity = nil
  @lines = nil
  class << self
    def add; @qb_action = "Add"; self end
    def mod; @qb_action = "Mod"; self end
    def del; @qb_action = "Del"; self end
    def void; @qb_action = "Void"; self end
    def query; @qb_action = "Query"; self end
  end
end
class QbCompany < QbWorker
  include QbRequest
  @qb_entity = "Customer"
  @t2_entity = Company
  @qb_action = nil
end
class QbInvoice < QbWorker
  include QbRequest
  @qb_entity = "Invoice"
  @t2_entity = Invoice
  @lines = QbInvoiceLine
  @qb_action = nil
end
class QbInvoiceline < QbWorker
  include QbRequest
  @qb_entity = "InvoiceLine"
  @t2_entity = InvoiceLine
  @qb_action = nil
end
class QbPayment < QbWorker
  include QbRequest
  @qb_entity = "ReceivePayment"
  @t2_entity = QbPayment
  @lines = QbInvoicePayment
  @qb_action = nil
end
class QbInvoicePayment < QbWorker
  include QbRequest
  @qb_entity = "PaymentLine"
  @t2_entity = InvoicePayment
  @qb_action = nil
end
module QbRequest
  extend self
  def form(parts = [])
    parts.map!{|part| part.to_s.camelize}.join("").underscore.to_sym
  end

  def rq; {form([@qb_action, @qb_entity, "Rq"]) => yield} end
  def rs; {form([@qb_action, @qb_entity, "Rs"]) => yield} end
  def ref; {form([@qb_entity, "Ref"]) => yield} end
  def ret; {form([@qb_entity, "Ref"]) => yield} end

  def lines
    @lines.nil? ? nil : @lines
  end

  def detail(key=nil)
    key.nil? ? nil : {key: yield}
  end
end
