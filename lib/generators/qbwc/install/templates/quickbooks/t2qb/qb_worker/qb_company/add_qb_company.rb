class AddQbCompany < QbWorker
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