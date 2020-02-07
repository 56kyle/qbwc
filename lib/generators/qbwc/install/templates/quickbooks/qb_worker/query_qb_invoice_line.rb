class QueryQbInvoiceLine < QbWorker
  def requests(job, session, data)
    make_runtime
    req = -> (qb_invoice) do
      {# TODO - This is all screwy, not usable yet.
       invoice_mod_rq: {
           invoice_mod: {
               invoice_line_group_mod: { # txn_line_id yields a list of invoice_line qb_id's and invoice_line_mod yields a list of invoices to be modified somehow.
                                         # TODO - Add invoice_lines.(unvoid).each when on T2
                                         txn_line_id: [qb_invoice.invoice_lines.each {|line| "#{line.qb_id}"}].reject{ |qb_id| data[:invoice_lines].each{|line| line.qb_id} },
                                         invoice_line_mod: [data[:invoice_lines].each{|line| line.qb_id.nil? ? {txn_line_id: -1}.merge{line} : {txn_line_id: line[:qb_id]}.merge(line)}]
               }
           }
       }
      }
    end
    super(job, session, data, &req)
  end
end
