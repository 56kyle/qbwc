module Qb
  module Payments
    class Query < Qb::QbP
      def should_run?(job, session, data)
        super do
          data[:id] || data.keys.select{|key| key.to_s.include?('filter')}.present?
        end
      end
      def requests(job, session, data)
        super do
          qbp.query.rq do
            {
                txn_id: txn_id,
                txn_date_range_filter: data[:txn_date_range_filter],
                entity_filter: data[:entity_filter],
                ref_number_filter: data[:ref_number_filter]
            }
          end
        end
      end

    end
  end
end

