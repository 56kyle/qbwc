class DelQbCompany < QbWorker
  def requests(job, session, data)
    make_runtime
    req = -> (qb_list_item) do
      {
          list_del_rq: {
              list_ref: {
                  list_id: qb_list_item[:qb_id]
              }
          }
      }
    end
    super(job, session, data, &req)
  end
end