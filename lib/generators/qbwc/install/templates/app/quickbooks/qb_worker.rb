#noinspection RubyIfCanBeCaseInspection
class QbWorker < QBWC::Worker
  # =Important= - Methods [:requests, :should_run, :handle_response] are the main few that QBWC calls. However, they should be treated like singleton methods.
  include Qb
  include Grammar
  attr_accessor :qb_entity, :t2_entity, :qb_type, :t2_instance, :chain

  def initialize(data = nil); set_t2_instance(data) if data end # When called by QBWC it is done with no parameters.

  def requests(job, session, data) # Ideally never is called directly unless trying to manually write a job.
    set_t2_instance(data)
    return parse_rq(yield) if block_given?
    nil
  end

  def should_run?(job, session, data) # Pretty important piece since it is difficult to modify QBWC queueing. However, it may take multiple QWC prompts for certain actions to complete.
    set_t2_instance(data)
    block_given? ? yield : nil
  end

  def handle_response(response, session, job, request, data) # data will hold about 90% of needed info due to QBWC constantizing a new class for every single method call...
    set_t2_instance(data)
    status = determine_status(response)
    yield(status) if block_given?
    run_post_actions(data)
    QBWC.delete_job(job)
  end

  def determine_status(response) # Extra parameters aren't used as inputs really, just making sure they are declared.
    xml_att = response ? response['xml_attributes'] : nil
    status = xml_att ? xml_att['statusSeverity'] : nil
  end

  def update_qb_id(data)
    if @t2_instance
      @t2_instance.update(qb_id: data[:qb_id]) if data[:qb_id]
    end
  end

  def set_t2_instance(data)
    @t2_instance = @t2_entity.find_by(id: data[:id]) if data && data[:id]
  end

  def run_post_actions(data)
    instance_eval(data[:after_do]) if data[:after_do].is_a?(String) # Avoiding the use of this unless for temporary fixes. Permanent use is asking for trouble.
  end

  def parse_rq(rq)
    case rq
    when Hash
      if rq.present? && rq.keys&.present?
        rq.each_key do |key|
          rq[key] = parse_rq(rq[key])
        end
        rq = rq.compact
        rq.present? ? rq : nil
      else
        nil
      end
    when Array
      if rq.present?
        rq = rq.map do |val|
          parse_rq(val)
        end
        rq = rq.compact
        rq.size == 0 ? nil : rq
      else
        nil
      end
    when NilClass
      nil
    when FalseClass
      'False'
    else
      rq
    end
  end

  class << self # Holds all "class methods" which happen to also be the methods used in creating new jobs.
    def act(qb_input)
      data = self.parse_input(qb_input)
      root_module = self.module_parent
      data[:qb_id] = self.qbid(data) unless data[:qb_id]
      case self.new
      when root_module::Add then self.add_act(data)
      when root_module::Mod then self.mod_act(data)
      when root_module::Del then self.del_act(data)
      when root_module::Query then self.query_act(data)
      when root_module::Void then self.void_act(data)
      else
        nil
      end
    end

    def add_act(data)
      if data[:id]
        self.make_job(data) unless self.new(data)&.t2_instance&.qb_id
      end
    end

    def mod_act(data) # Since the information is not pulled from t2 until the request is processed, if there is already a mod in queue then another would be redundant.
      undesired_actions = [self.module_parent::Add.to_s, self.module_parent::Mod.to_s]
      QBWC.get_job({})
      return nil if QBWC.jobs.map{|j| [j.worker_class, j.data[:id]]}.select{|j_array| undesired_actions.include?(j_array[0]) && data[:id] == j_array[1]}.present?
      self.make_query(data) unless data[:qb_id]
      self.make_job(data)
    end

    def del_act(data) # This one is a bit weird due to the t2_instance being lost before request processing. Data holds all necessary values to delete.
      self.remove_instance_jobs_when do |j_array| # j_array = QBWC.jobs.map{|j| [j.name, j.worker_class, j.data[:id]] }
        worker_parent_module_name = j_array[1].split('::')[0,1].join('::')
        if worker_parent_module_name == self.module_parent.to_s
          j_array[1] != self.to_s && j_array[2] == data[:id]
        end
      end
      self.make_job(data) if data[:qb_id]
    end

    def query_act(data)
      self.make_job(data) if data[:qb_id] || data.keys.select{|key| key.to_s.underscore.include?('filter')}&.present?
    end

    def void_act(data)
      self.make_job(data) if data[:qb_id]
    end

    def remove_instance_jobs_when
      qb_jobs = QBWC.jobs
      arrays = qb_jobs.map{ |j| [j.name, j.worker_class, j.data[:id]]}
      to_be_removed = arrays.select{|ar|yield(ar)}
      to_be_removed.each do |j_array|
        QBWC.delete_job(j_array.first.to_sym)
      end
    end

    def qbid(data)
      self.find_attr(:qb_id, data)
    end

    def find_attr(attr, data)
      t2_inst = self.new(data).t2_instance
      return t2_inst.method(attr).call if t2_inst&.respond_to?(attr) && t2_inst.method(attr)&.call&.present?
      data[attr]
    end

    def parse_input(qb_input)
      case qb_input
      when Array
        qb_input.each { |iter| self.act(iter) }; nil # Arrays will iterate but must return nil; avoiding qb_input = []
      when Numeric
        {id: qb_input}
      when Hash
        qb_input
      else # Had trouble with entities not catching in the case statement so now they just get caught in else.
        data = {}
        data[:id] = qb_input.id if qb_input.respond_to?(:id)
        data[:qb_id] = qb_input.qb_id if qb_input.respond_to?(:qb_id)
        data.present? ? data : nil
      end
    end

    def needs_query? # AKA does this need a qb_id?
      root = self.module_parent
      case self.new
      when root::Mod then true
      when root::Del then true
      when root::Void then true
      else false
      end
    end

    def make_job_name(data) # QBWC uses the job name as a primary key. Using the current time since epoch in the name removes any chance of error.
      name_array = ['Job', "_#{Time.now.to_i}"] + self.to_s.split('::')[1,2] + ['Id_', data[:id].to_s]
      name_array.join('').underscore
    end

    def make_query(data)
      data[:qb_id] = @t2_instance.qb_id if @t2_instance&.qb_id
      self.module_parent::Query.make_job(data)
    end

    def make_job(data) # QBWC.add_job with less of the pain caused by 5 mandatory parameters.
      QBWC.add_job(self.make_job_name(data), true, nil, self, nil, data)
    end

    # ================== Filters below ===========================================
    def name_filter(data)
      if data[:name_filter]
        data[:name_filter]
      end
    end

    def txn_date_range_filter(data)
      if data[:txn_date_range_filter]
        {
            from_txn_date: data[:txn_date_range_filter][:from_txn_date],
            to_txn_date: data[:txn_date_range_filter][:to_txn_date]
        }
      end
    end

    def entity_filter(data)
      if data[:entity_filter]
        {
            full_name: data[:entity_filter][:full_name]
        }
      end
    end

    def ref_number_filter(data)
      if data[:ref_number_filter]
        {
            match_criteria: data[:ref_number_filter][:match_criteria],
            ref_number: data[:ref_number_filter][:ref_number]
        }
      else
        nil
      end
    end
  end
end

