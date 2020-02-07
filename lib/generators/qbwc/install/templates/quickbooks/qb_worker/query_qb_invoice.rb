class QueryQbInvoice < QbWorker
  def requests(job, session, data)
    make_runtime
    req = -> (qb_invoice) do
      {
          invoice_query_rq:    {
              txn_id:                qb_invoice.qb_id,
              ref_number:            qb_invoice.ref_number,
              txn_date_range_filter: {
                  from_txn_date: qb_invoice['from_txn_date'],
                  to_txn_date:   qb_invoice['to_txn_date']
              },
              #entity_filter:         {
              #    list_id:   qb_invoice['list_id'],
              #    full_name: qb_invoice['full_name']
          },
          include_ret_element: %w( txn_id, customer_ref, txn_date, ref_number, linked_txn )
      }
    end
    super(job, session, data, &req)
  end
end