class QueryQbPayment < QbWorker
  def requests(job, session, data)
    make_runtime
    req = -> (qb_payment) do
      {
        receive_payment_query_rq: {
          txn_id:                qb_payment['txn_id'],
          txn_date_range_filter: {
            from_txn_date: qb_payment['from_txn_date'],
            to_txn_date:   qb_payment['to_txn_date']},
          entity_filter:         {
            full_name: qb_payment['full_name']},
          #ref_number_filter:     {
          #    match_criterion: qb_payment['match_criterion'],
          #    ref_number:      qb_payment['ref_number']},
          include_ret_element:
            %w(tnx_id customer_ref ref_number total_amount)}
      }
    end
    super(job, session, data, &req)
  end
end