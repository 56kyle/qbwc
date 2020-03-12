module Qb
  class QbP < QbWorker
    include Payments

    def initialize(data= nil)
      @qb_entity = "ReceivePayment"
      @t2_entity = Payment
      super
    end

    def handle_response(response, session, job, request, data)
      super do |status|
        r = nil
        r = block_given? ? yield : response['receive_payment_ret'] if response
        if status == 'Info' && r
          data[:qb_id] = r['txn_id'] if r['txn_id']
          data[:edit_sequence] = r['edit_sequence'] if r['edit_sequence']
          job.data=(data)
          update_qb_id(data) unless @t2_instance&.qb_id
        end
      end
    end

    def customer_ref
      qbp_c = Qb::QbC.new(qbc)
      {
          list_id: qbp_c.list_id,
          full_name: qbp_c._name
      }
    end

    def applied_to_txn_add
      {
          txn_id: @t2_instance.invoices.first.qb_id,
          payment_amount: "%.2f" % @t2_instance.amount
      }
    end

    def applied_to_txn_mod(data)
      if data[:invoice_payments]
        {
            txn_line_id: @t2_instance.invoices.first.qb_id,
            edit_sequence: data[:invoice_payments],
            payment_amount: "%.2f" % @t2_instance.amount
        }
      end
    end

    def qbp; nil; block_given? ? made(@qb_entity) do yield end : made(@qb_entity) end
    def qbi; @t2_instance.invoices if @t2_instance end
    def qbc; @t2_instance.company if @t2_instance end
    def qbip; @t2_instance.invoice_payments if @t2_instance end
    def txn_id; @t2_instance ? @t2_instance.qb_id || data[:qb_id] : data[:qb_id] end
    def txn_date; @t2_instance.payment_date if @t2_instance end
    def ref_number; @t2_instance.ref_number if @t2_instance end
    def total_amount; "%.2f" % @t2_instance.amount if @t2_instance end
  end
end

