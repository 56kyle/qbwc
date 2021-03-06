module Qb
  module Invoices
    class Mod < Qb::QbI
      def should_run?(job, session, data)
        super do
          if @t2_instance&.qb_id
            @t2_instance.company&.qb_id ? true : false
          else
            false
          end
        end
      end

      def requests(job, session, data)
        super do
          qbi.mod.rq do
            qbi.mod do
              {
                  txn_id: data[:qb_id],
                  edit_sequence: data[:edit_sequence],
                  customer_ref: customer_ref,
                  txn_date: txn_date,
                  ref_number: ref_number,
                  is_pending: is_pending,
                  due_date: due_date,
                  invoice_line_mod: invoice_line_mod(data)
              }
            end
          end
        end
      end

    end
  end
end

