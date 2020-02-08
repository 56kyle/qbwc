module T2Qb
  autoload :QbWorker, 't2qb/qb_worker.rb'
  autoload :QbHook, 't2qb/qb_hook'
  autoload :QbUtil, 't2qb/qb_util'
  autoload :QbWorkerUtil, 't2qb/qb_worker_util'

  mattr_reader :t2_entities
  @@t2_entities = [Company, Invoice, InvoiceLine, InvoicePayment]

  mattr_reader :qb_actions
  @@qb_actions = [Add, Mod, Del, Query, Void]



  class << self
    def qb_update_all

    end
    def to_qb
      if self.t
    end
  end
end
