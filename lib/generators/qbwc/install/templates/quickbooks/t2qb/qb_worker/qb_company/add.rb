module T2Qb::QbWorker::QbCompany::Add
  class AddQbCompany < QBWC::Worker
    def initialize
      puts super
      @qb_entity = :qb_entity
    end
    def requests(job, session, data)
      make_runtime
      req = -> (qb_company) do
        {customer_add_rq: {
            customer_add:     {
              name:         qb_company[:name],
              company_name: qb_company[:name]
            }
          }
        }
      end
      super(job, session, data, &req)
    end
  end
end