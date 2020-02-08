class DelQbInvoiceLine < QbWorker
  def requests(job, session, data)
    make_runtime
    req = -> (qb_txn) do
      {
          txn_del_rq: {
              txn_ref: {
                  txn_id: qb_txn[:qb_id]
              }
          }
      }
    end
    super(job, session, data, &req)
  end
end
