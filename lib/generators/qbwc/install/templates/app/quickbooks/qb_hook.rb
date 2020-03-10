module QbHook
  # Adds callbacks and Quickbooks functionality.
  extend ActiveSupport::Concern
  included do
    after_commit on: [:create] do self.class.qb_add(self) end
    after_commit on: [:update] do # Since each entity only needs 0-1 updates per QBW cycle this only runs once. Every other time gets caught soon.
      self.class.qb_void if self.respond_to?(:void) && self&.void
      self.class.qb_mod(self)
    end
    before_commit on: [:destroy] do self.class.qb_del(self) end # Since we are working with commit based callbacks, destroy has to be before.

    def self.qb_add(qb_in); "Qb::Qb#{self.to_s.scan(/[A-Z]/).join('')}::Add".constantize.act(qb_in) end # Qb::[Companies, Invoices, Payments]::Add.act(*New Instance of Company/etc.*)
    def self.qb_mod(qb_in); "Qb::Qb#{self.to_s.scan(/[A-Z]/).join('')}::Mod".constantize.act(qb_in) end
    def self.qb_del(qb_in); "Qb::Qb#{self.to_s.scan(/[A-Z]/).join('')}::Del".constantize.act(qb_in) end
    def self.qb_query(qb_in); "Qb::Qb#{self.to_s.scan(/[A-Z]/).join('')}::Query".constantize.act(qb_in) end
    def self.qb_void(qb_in); "Qb::Qb#{self.to_s.scan(/[A-Z]/).join('')}::Void".constantize.act(qb_in) end unless self == Company # Quickbooks will not allow companies to be voided.
  end
end

