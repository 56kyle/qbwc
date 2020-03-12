module Qb
  module Payments
    class Mod < Qb::QbP
      def should_run?(job, session, data)
        super do
          if @t2_instance&.qb_id
            @t2_instance.invoices&.select{|qbp_i| qbp_i&.qb_id }&.present? && @t2_instance.company&.qb_id ? true : false
          end
        end
      end

      def requests(job, session, data)
        super do
          qbp.mod.rq do
            qbp.mod do
              {
                  txn_id: data[:qb_id],
                  edit_sequence: data[:edit_sequence],
                  customer_ref: customer_ref,
                  txn_date: txn_date,
                  ref_number: ref_number,
                  total_amount: total_amount,
                  payment_method_ref: {
                      full_name: 'cash'
                  },
                  applied_to_txn_mod: applied_to_txn_mod(data)
              }
            end
          end
        end
      end

    end
  end
end

