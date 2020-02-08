module T2Qb
  module QbWorker
    module QbInvoiceLine
      mattr_reader :qb_entity
      @@qb_entity = "InvoiceLine"

      mattr_reader :t2_entity
      @@t2_entity = InvoiceLine

      mattr_reader :qb_id_type
      @@qb_id_type = :txn_id
    end
  end
end