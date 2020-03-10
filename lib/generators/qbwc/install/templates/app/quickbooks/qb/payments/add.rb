module Qb
  module Payments
    class Add < Qb::QbP
      def should_run?(job, session, data)
        super do
          @t2_instance&.invoices&.select{|qbp_i| qbp_i&.qb_id }&.present?
        end
      end

      def requests(job, session, data)
        super do
          qbp.add.rq do
            qbp.add do
              {
                  customer_ref: customer_ref,
                  txn_date: txn_date,
                  ref_number: ref_number,
                  total_amount: total_amount,
                  is_auto_apply: true
              }
            end
          end
        end
      end

    end
  end
end

