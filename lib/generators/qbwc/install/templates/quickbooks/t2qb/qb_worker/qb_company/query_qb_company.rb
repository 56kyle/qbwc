class QueryQbCompany < QbWorker
  def requests(job, session, data)
    make_runtime
    req = -> (qb_company) do
      {
        company_query_rq: {
          list_id:             qb_company.qb_id,
          full_name:           qb_company.name
        #name_filter:         {
        #    match_criterion: qb_company.match_criterion,
        #      name:            qb_company.name_filter_name
        },
        include_ret_element: %w(list_id, full_name)
      }
    end
    super(job, session, data, &req)
  end
end