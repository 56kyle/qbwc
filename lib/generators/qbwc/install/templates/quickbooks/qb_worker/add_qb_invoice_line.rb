class AddQbInvoiceLine < QbWorker
  def requests(job, session, data)
    make_runtime
    req = -> (qb_invoice_line) do
      {
                            invoice_line_add_rq: {
                                invoice_line_add: {
                                    amount:      qb_invoice_line[:amount],
                                    link_to_txn: {
                                        txn_id: Invoice.find_by_id(id: qb_invoice_line[:invoice_id][:qb_id])}}}}
    end
    super(job, session, data, &req)
  end
end