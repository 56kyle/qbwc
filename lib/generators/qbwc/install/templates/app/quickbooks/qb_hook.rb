module QbHook
  # Adds callbacks and Quickbooks functionality.
  extend ActiveSupport::Concern
  included do
    @qb_entity_class = "Qb::Qb#{self.to_s.scan(/[A-Z]/).join('')}".constantize

    after_commit on: [:create] do self.class.qb_add(self) end
    after_commit on: [:update] do self.class.qb_mod(self) end # Since each entity only needs 0-1 updates per QBW cycle this only runs once. Every other time gets caught soon.
    before_commit on: [:destroy] do self.class.qb_del(self) end # Since we are working with commit based callbacks, destroy has to be before.

    def self.qb_add(qb_in); @qb_entity_class::Add.act(qb_in) end # Qb::[Companies, Invoices, Payments]::Add.act(*New Instance of Company/etc.*)
    def self.qb_mod(qb_in); @qb_entity_class::Mod.act(qb_in) end
    def self.qb_del(qb_in); @qb_entity_class::Del.act(qb_in) end
    def self.qb_query(qb_in); @qb_entity_class::Query.act(qb_in) end
    def self.qb_void(qb_in); @qb_entity_class::Void.act(qb_in) end unless self == Company # Quickbooks will not allow companies to be voided.
  end
end

