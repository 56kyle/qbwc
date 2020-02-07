class ModQbPayment < QbWorker
  def requests(job, session, data)
    make_runtime
    req = -> (qb_payment) do
      {
        receive_payment_mod_rq: {
            receive_payment_mod: {
                receive_payment_line_group_mod: {
                    txn_line_id: [qb_payment.each{|line| line.qb_id}.select{|qb_id| qb_id.nil?}],
                    receive_payment_line_mod: [
                                     data[:payment_lines].each do |line|
                                       {
                                           txn_line_id:
                                               line[:qb_id].present? ? line[:qb_id] : -1
                                       }.merge(line)
                                     end
                                 ]
                }
            }
        }
      }
    end
    super(job, session, data, &req)
  end
end
