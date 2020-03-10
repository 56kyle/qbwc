module Qb
  class QbI < QbWorker
    include Invoices

    def initialize(t2_instance= nil)
      @qb_entity = "Invoice"
      @t2_entity = Invoice
      @qb_bill_types = {1=>"Audit", 2=>"Brands Fee", 3=>"Brands Installment Fee", 4=>"Cancellation Credit", 5=>"Deposit", 6=>"Endorsement", 7=>"Inst Fee", 8=>"Installment", 9=>"Late Fee", 10=>"Monthly Report", 11=>"NSF Fee", 12=>"Policy Premium", 13=>"Quote", 14=>"STC", 15=>"Surety Bonds", 16=>"Taxes", 17=>"Previous Balance", 18=>"Commission", 19=>"Tiger Escrow Rollover", 20=>"Escrow Rollover", 21=>"SaferWatch Fee", 22=>"Taxes-C", 23=>"Reinstatement Fee", 24=>"Policy Rec Premium", 25=>"NC Reinsurance Facility Recoupment Fee", 26=>"Reinstatment", 27=>"Policy Rec Deposit"}
      super
    end

    def handle_response(response, session, job, request, data)
      super do |status|
        r = nil
        r = block_given? ? yield : response['invoice_ret'] if response
        if status == 'Info'
          data[:qb_id] = "#{r['txn_id'].split('-').first}-#{r['edit_sequence']}" if r['txn_id'] && r['edit_sequence']
          job.data=(data)
          update_qb_id(data)
        end

      end
    end

    def customer_ref
      qbi_c = Qb::QbC.new(qbc)
      {
          list_id: qbi_c.list_id,
          full_name: qbi_c._name
      }
    end

    def invoice_line_add
      @t2_instance.invoice_lines.map { |il|
        {item_ref: {
                full_name: item_codes[@t2_instance.bill_type]
            },
            desc: @t2_instance.description,
            amount: "%.2f" % il.amount
        }}
    end

    def qbi; block_given? ? made(@qb_entity) do yield end : self.chain=nil; made(@qb_entity) end
    def qbil; @t2_instance.invoice_lines if @t2_instance end
    def qbc; @t2_instance.company if @t2_instance end
    def qbp; @t2_instance.invoice_payments if @t2_instance end
    def txn_id; @t2_instance ? @t2_instance.qb_id || data[:qb_id] : data[:qb_id] end
    def txn_date; @t2_instance.generated_date if @t2_instance end
    def ref_number; @t2_instance.invoice_number if @t2_instance end
    def due_date; @t2_instance.due_date if @t2_instance end
    def is_pending; if @t2_instance.invoice_payments; @t2_instance.invoice_payments.present? else; true end end
    def service_date; @t2_instance.generated_date if @t2_instance end

    def item_codes
      ["Audit", "Brands Fee", "Brands Installment Fee", "Cancellation Credit", "Deposit", "Endorsement", "Inst Fee", "Installment", "Late Fee", "Monthly Report", "NSF Fee", "Policy Premium", "Quote", "STC", "Surety Bonds", "Taxes", "Previous Balance", "Commission", "Tiger Escrow Rollover", "Escrow Rollover", "SaferWatch Fee", "Taxes-C", "Reinstatement Fee", "Policy Rec Premium", "NC Reinsurance Facility Recoupment Fee", "Reinstatment", "Policy Rec Deposit"]
    end
  end
end

