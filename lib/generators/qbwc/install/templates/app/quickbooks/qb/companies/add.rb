module Qb
  module Companies
    class Add < Qb::QbC
      def should_run?(job, session, data)
        super do
          @t2_instance ? true : false
        end
      end

      def requests(job, session, data)
        super do
          qbc.add.rq do
            qbc.add do
              {
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

