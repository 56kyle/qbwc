module Qb
  class QbC < QbWorker
    include Companies

    def initialize
      @qb_entity = "Customer"
      @t2_entity = Company
      super
    end

    def handle_response(response, session, job, request, data)
      super do |status|
        r = nil
        r = block_given? ? yield : response['customer_ret'] if response
        if status == 'Info'
          data[:qb_id] = "#{r['list_id'].split('-').first}-#{r['edit_sequence']}" if r['list_id'] && r['edit_sequence']
          job.data=(data)
          update_qb_id(data)
        end
      end
    end

    def qbc; block_given? ? made(@qb_entity) do yield end : made(@qb_entity) end
    def qbi; @t2_instance.invoices.map{ |qb_inv| Qb::QbI.new(qb_inv) } end
    def qbp; @t2_instance.payments.map{ |qb_pay| Qb::QbP.new(qb_pay) } end
    def _name; @t2_instance.name if @t2_instance&.name end
    def company_name; @t2_instance.name if @t2_instance&.name end
    def list_id; @t2_instance.qb_id if @t2_instance&.qb_id end
    def full_name; @t2_instance.name if @t2_instance&.name end
  end
end
