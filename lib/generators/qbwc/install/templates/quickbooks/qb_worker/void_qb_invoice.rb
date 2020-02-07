class VoidQbInvoice < QbWorker
  def requests(job, session, data)
    make_runtime
    req = -> (qb_txn) do
      {
        txn_void_rq: {
          txn_ref: {
            txn_id: "#{qb_txn[:qb_id]}"
          }
        }
      }
    end
    super(job, session, data, &req)
  end
end
