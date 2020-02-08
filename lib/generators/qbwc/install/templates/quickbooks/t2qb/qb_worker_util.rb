module T2Qb::QbWorkerUtil
  def make_runtime # Called from qb_worker in requests.
    # **Important** - Don't call this in an initializer in the workers or elsewhere.
    # It is called by the qb_worker (almost)every method due to QBWC not working off of objects in memory, but rather the marked klass in MySQL.
    unless self.action.present?
      klass_str      = self.class.to_s
      vals           = klass_str.match(/(.*)Qb(.*)/)
      self.t2_entity = vals[2].constantize rescue puts "make_runtime could not make #{self.to_s}.t2_entity"; nil
      self.action = vals[1].underscore.to_sym rescue puts "make_runtime could not make #{self.to_s}.action"; nil
      true
    end
  end

  def qb_data_to_instance(data, &block)
    # Runs from QbWorker.requests being called by a t2qb klass using super do |qb_obj|...
    case data
    when Hash
      puts "Hash: #{data}"
      data[:id].present? ? qb_data_to_instance(data[:id], &block) : data
    when Integer, Symbol
      puts "Int or Sym: #{data}"
      self.t2_entity.find_by(id: data)
    when self.t2_entity # Can be removed if else is made to return data. Depends on how much we want to trust data input.
      puts "Entity: #{data}"
      data
    else
      nil
    end
  end

  def qb_requests_parse(requests)
    # Typically run from QbWorker.requests with the pre-parsed request as "requests"
    if requests.class == Hash
      requests.each_pair do |key, val|
        if qb_requests_parse(val).nil?
          requests.delete(key)
        end
      end
    end
    if requests.class == Array
      requests.delete_if{|val| qb_requests_parse(val).nil?}
    end
    requests.present? && !requests.nil? ? requests : nil
  end

end