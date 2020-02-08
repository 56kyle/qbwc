module T2Qb
  module QbWorker
    module QbCompany
      mattr_reader :qb_entity
      @@qb_entity = "Customer"

      mattr_reader :t2_entity
      @@t2_entity = Company

      mattr_reader :qb_id_type
      @@qb_id_type = :list_id
    end
  end
end