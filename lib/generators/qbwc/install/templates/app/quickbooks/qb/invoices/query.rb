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
              ref_number: ref_number,
              txn_date_range_filter: data[:txn_date_range_filter]
            }
          end
        end
      end

    end
  end
end

