module Qb
  module Companies
    class Query < Qb::QbC
      def should_run?(job, session, data)
        super do
          data[:id] || data.keys.select{|key| key.to_s.include?('filter')}.present?
        end
      end

      def requests(job, session, data)
        super do
          qbc.query.rq do
            {
              list_id: list_id,
              name_filter: data[:name_filter]
            }
          end
        end
      end
      def handle_response(response, session, job, request, data)
        super do
          response['customer_ret'][0]
        end
      end

    end
  end
end

