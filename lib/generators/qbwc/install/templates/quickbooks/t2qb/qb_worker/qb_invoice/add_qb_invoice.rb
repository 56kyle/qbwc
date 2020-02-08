class AddQbInvoice < QbWorker
  def requests(job, session, data)
    make_runtime
    req = -> (qb_invoice) do
      qb_lines = qb_invoice.invoice_lines
      qb_payments = qb_invoice.invoice_payments.any?
      {
          invoice_add_rq: {
              invoice_add: {
                  customer_ref: {
                      full_name: Company.find_by(id: qb_invoice[:company_id]).name
                  },
                  txn_date:     qb_invoice[:generated_date],
                  ref_number:   qb_invoice[:id],
                  due_date:     qb_invoice[:due_date],
                  is_pending: qb_payments,

                  invoice_line_add: qb_lines.each do |line|
                    {
                        desc: line[:description],
                        amount: line[:amount]
                    }
                  end
              }
          }
      }
    end
    super(job, session, data, &req)
  end
end