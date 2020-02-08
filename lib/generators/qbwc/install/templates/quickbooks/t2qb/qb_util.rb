module T2Qb::QbUtil
  extend self
  # Contains general functions to integrate Qb
  def job_count
    QBWC.jobs.length
  end

  def qb_do(qb_worker, qb_input)
    if qb_worker.superclass == QbWorker
      if qb_input.is_a?(Enumerable)
        qb_input.each{|iter| qb_worker.act(iter)}
      else
        qb_worker.act(qb_input)
      end
    end
  end
end