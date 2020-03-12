module Qb
  module Invoices
    class Query < Qb::QbI
      def should_run?(job, session, data)
        super do
          data[:id] || data.keys.select{|key| key.to_s.include?('filter')}.present?
        end
      end

      def requests(job, session, data)
        super do
          qbi.query.rq do
            {
              txn_id: txn_id,
              ref_number: data[:ref_number_filter],
              txn_date_range_filter: data[:txn_date_range_filter]
            }
          end
        end
      end
      def handle_response(response, session, job, request, data)
        super do
          response['invoice_ret'][0]
        end
      end

    end
  end
end

