class AddQbPayment < QbWorker
  def requests(job, session, data)
    # TODO - This request shouldn't use auto apply in the end. Seems way too susceptible to issues accumulating.
    make_runtime
    req = -> (qb_payment) do
      invoice_payments = InvoicePayment.find_by(id: :payment_id)
      {receive_payment_add_rq: {
              receive_payment_add: {
                  customer_ref:        {
                      full_name: Company.find_by_id(id: qb_payment[:company_id])},
                  txn_date:            "#{qb_payment[:payment_date]}",
                  ref_number:          "#{qb_payment[:ref_number]}",
                  total_amount:        "#{qb_payment[:amount]}",
                  is_auto_apply:       false,
                  applied_to_txn_add: invoice_payments.each do |inv_pay|
                    {}
                  end
              },
              include_ret_element: 'txn_id'}
      }
    end
    super(job, session, data, &req)
  end
end
