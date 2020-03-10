module Qb
  module Invoices
    class Del < Qb::QbI
      def should_run?(job, session, data)
        super do
          data[:qb_id] ? true : false
        end
      end

      def requests(job, session, data)
        super do
          {
              txn_del_rq: {
                  txn_del_type: @qb_entity,
                  txn_id: data[:qb_id]
              }
          }
        end
      end

      def handle_response(response, session, job, request, data)
        super do
          response['txn_del_rs'] if response
        end
      end

    end
  end
end

