module QbWorker::QbInvoice
  mattr_reader :qb_entity
  @@qb_entity = "Invoice"

  mattr_reader :t2_entity
  @@t2_entity = InvoiceLine

  mattr_reader :qb_id_type
  @@qb_id_type = :txn_id
end
