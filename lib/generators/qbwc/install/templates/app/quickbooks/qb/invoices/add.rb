module Qb
  module Invoices
    class Add < Qb::QbI
      def should_run?(job, session, data)
        super do
          @t2_instance&.company&.qb_id ? true : false
        end
      end

      def requests(job, session, data)
        super do
          qbi.add.rq do
            qbi.add do
              {
                  customer_ref: customer_ref,
                  txn_date: txn_date,
                  ref_number: ref_number,
                  is_pending: is_pending,
                  due_date: due_date,
                  invoice_line_add: invoice_line_add
              }
            end
          end
        end
      end

    end
  end
end

