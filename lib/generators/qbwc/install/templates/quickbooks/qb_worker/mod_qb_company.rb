class ModQbCompany < QbWorker
  def requests(job, session, data)
    make_runtime
    req = -> (qb_company) do
      {customer_mod_rq: {
              customer_mod: {
                list_id: "#{qb_company[:qb_id]}",
                full_name: "#{qb_company[:name]}"
              }.merge(data)
          }
      }
    end
    super(job, session, data, &req)
  end
end