module T2Qb::QbHook
  # This module serves as the hook for updating Qb to T2's changes. It also adds some functionality for T2 to modify Qb.
  extend ActiveSupport::Concern

  included do
    after_create_commit do |qb_obj|
      call_qb_add(qb_obj)
    end
    after_destroy_commit do |qb_obj|
      call_qb_del(qb_obj)
    end
    def call_qb_add(qb_obj)
      self.class.qb_add(qb_obj)
    end
    def call_qb_del(qb_obj)
      self.class.qb_del(qb_obj)
    end
    # Instance wrappers of #{t2_entity}.qb_#{action}
    def qb_add; self.class.qb_add(self) end
    def qb_mod; self.class.qb_add(self) end
    def qb_query; self.class.qb_query(self) end
    def qb_void; self.class.qb_void(self) end
    def qb_del; self.class.qb_del(self) end
  end

  class_methods do
    def qb_actions
      res = nil
      self == Invoice ? res = {add: AddQbInvoice, mod: ModQbInvoice, del: DelQbInvoice, void: VoidQbInvoice, query: QueryQbInvoice} : nil
      self == InvoiceLine ? res = {add: AddQbInvoiceLine, mod: ModQbInvoiceLine, del: DelQbInvoiceLine, void: VoidQbInvoiceLine, query: QueryQbInvoiceLine} : nil
      self == Payment ? res = {add: AddQbPayment, mod: ModQbPayment, del: DelQbPayment, void: VoidQbPayment, query: QueryQbPayment} : nil
      self == Company ? res = {add: AddQbCompany, mod: ModQbCompany, del: DelQbCompany, query: QueryQbCompany} : nil
      res
    end

    # Defines "#{t2_model_class}.qb_#{model_action}(arg)" for all permitted actions.
    # Example - Invoice.qb_add(an_invoice) or Payment.qb_void(array_of_payment_ids)
    def qb_add(qb_obj); qb_actions[:add].act(qb_obj) end # Uses worker.act instead of qb_do for optimizations sake. Can use qb_do if preferred.
    def qb_mod(qb_obj); qb_actions[:mod].act(qb_obj) end
    def qb_query(qb_obj); qb_actions[:query].act(qb_obj) end
    def qb_void(qb_obj); qb_actions[:void].act(qb_obj) end
    def qb_del(qb_obj); qb_actions[:del].act(qb_obj) end
  end

end