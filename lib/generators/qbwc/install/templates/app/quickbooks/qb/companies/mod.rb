module Qb
  module Companies
    class Mod < Qb::QbC
      def should_run?(job, session, data)
        super do
          @t2_instance&.qb_id ? true : false
        end
      end

      def requests(job, session, data)
        super do
          qbc.mod.rq do
            qbc.mod do
              {
                  list_id: data[:qb_id],
                  edit_sequence: data[:qb_id].split('-').second,
                  name: _name,
                  company_name: company_name
              }
            end
          end
        end
      end

    end
  end
end

