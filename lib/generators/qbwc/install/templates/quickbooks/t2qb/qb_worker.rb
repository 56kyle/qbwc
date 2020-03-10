module T2Qb::QbWorker
  autoload :QbCompany, 'qb_worker/qb_company'
  autoload :QbInvoice, 'qb_worker/qb_invoice'
  autoload :QbInvoiceLine, 'qb_worker/qb_invoice_line'
  autoload :QbPayment, 'qb_worker/qb_payment'

  mattr_reader :t2_entities
  @@t2_entities = [Company, Invoice, InvoiceLine, Payment]

  mattr_


  def requests(job, session, data, &block) # Ideally never is called directly unless trying to manually write a job.
    self.t2_instance = qb_data_to_instance(data, &block)
    pre_parse        = block.call(self.t2_instance)
    qb_requests_parse(pre_parse)
  end

  def should_run?(job, session, data) # Just writing this to make visible Worker.should_run? as an option for controlling when Qb can update.
    block_given? ? yield : true
  end

  def handle_response(r, session, job, request, data) # Invoked by t2qb classes with super{"worker specific actions"}
    make_runtime
    qb_id     = case self.t2_entity
                when Invoice then r[:invoice_ret][:txn_id]
                when InvoiceLine then r[:invoice_ret][:invoice_line_group_ret][:invoice_line_ret][:txn_id]
                when Company then r[:customer_ret][:list_id]
                when Payment then r[:receive_payment_ret][:txn_id]
                when InvoicePayment then r[:receive_payment_ret][:applied_to_txn_ret][:txn_id]
                else nil
                end
    self.t2_entity.find_by(id: data[:id]).update(qb_id: qb_id) unless qb_id.nil?
    QBWC.delete_job(job)
  end

  def self.act(qb_input, delay= false) # Serves as act action for every worker since all call super.
    # ideally qb_input is in the form of an entity, contains only dead-ends that are integers corresponding to desired id's, or has a hash with key id.
    qb_input = case qb_input # Is recursive; Returns nil so it has a way to not re-do previous actions.
               when Array
                 qb_input.each { |iter| self.act(iter) }; nil # Arrays will iterate but must return nil; avoiding qb_input = []
               when Hash
                 qb_input[:id].present? ? self.act(qb_input[:id]) : qb_input
               when Integer
                 {id: qb_input}
               when Invoice, InvoiceLine, InvoicePayment, Payment, Company # Just keeping this here in case it is preferable to not trust input at a later point.
                 qb_input
               else
                 qb_input
               end

    unless qb_input.nil?
      qb_job = "#{self.to_s.underscore}_#{QbUtil.job_count + 1}".to_sym
      if delay
        QBWC.add_job(qb_job, true, nil, self, nil, qb_input)
      else
        req = self.new.requests(nil,nil, qb_input)
        QBWC.add_job(qb_job, true, nil, self, req, nil) unless req.nil?
      end
    end

    return nil
  end
end