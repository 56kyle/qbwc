module Qb
  module Companies
    class Del < Qb::QbC
      def should_run?(job, session, data)
        super do
          data[:qb_id] ? true : false
        end
      end

      def requests(job, session, data)
        super do
          {
              list_del_rq: {
                  list_del_type: @qb_entity,
                  list_id: data[:qb_id]
              }
          }
        end
      end

      def handle_response(response, session, job, request, data)
        super do
          response['list_del_rs'] if response
        end
      end

    end
  end
end

