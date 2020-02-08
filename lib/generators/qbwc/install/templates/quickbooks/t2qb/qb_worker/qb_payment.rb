module QbWorker::QbPayment
  autoload
  mattr_reader :qb_entity
  @@qb_entity = "RecievePayment"

  mattr_reader :t2_entity
  @@t2_entity = Payment

  mattr_reader :qb_id_type
  @@qb_id_type = :txn_id
end