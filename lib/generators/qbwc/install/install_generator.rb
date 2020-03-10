require 'rails/generators'
require 'rails/generators/active_record'

module QBWC
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      extend Rails::Generators::Migration

      namespace "qbwc:install"
      desc "Copies over qbwc default files and adds a quickbooks directory for T2 specific code."
      source_root File.expand_path('../templates', __FILE__)
      argument :controller_name, :type => :string, :default => 'qbwc'

      def make_quickbooks_directories
        aq = 'app/quickbooks/'
        directory(aq)
        directory(aq + 'qb/')
        directory(aq + 'qb/companies/')
        directory(aq + 'qb/invoices/')
        directory(aq + 'qb/payments/')
      end

      def copy_under_quickbooks
        aq = 'app/quickbooks/'

        template(aq + 'qb_worker.rb', aq + 'qb_worker.rb')
        template(aq + 'qb_hook.rb', aq + 'qb_hook.rb')
        template(aq + 'grammar.rb', aq + 'grammar.rb')
        template(aq + 'README.md', aq + 'README.md')

        template(aq + 'qb/qb_c.rb', aq + 'qb/qb_c.rb')
        template(aq + 'qb/qb_i.rb', aq + 'qb/qb_i.rb')
        template(aq + 'qb/qb_p.rb', aq + 'qb/qb_p.rb')

        template(aq + 'qb/companies/add.rb', aq + 'qb/companies/add.rb')
        template(aq + 'qb/companies/mod.rb', aq + 'qb/companies/mod.rb')
        template(aq + 'qb/companies/del.rb', aq + 'qb/companies/del.rb')
        template(aq + 'qb/companies/query.rb', aq + 'qb/companies/query.rb')

        template(aq + 'qb/invoices/add.rb', aq + 'qb/invoices/add.rb')
        template(aq + 'qb/invoices/mod.rb', aq + 'qb/invoices/mod.rb')
        template(aq + 'qb/invoices/del.rb', aq + 'qb/invoices/del.rb')
        template(aq + 'qb/invoices/query.rb', aq + 'qb/invoices/query.rb')
        template(aq + 'qb/invoices/void.rb', aq + 'qb/invoices/void.rb')

        template(aq + 'qb/payments/add.rb', aq + 'qb/payments/add.rb')
        template(aq + 'qb/payments/mod.rb', aq + 'qb/payments/mod.rb')
        template(aq + 'qb/payments/del.rb', aq + 'qb/payments/del.rb')
        template(aq + 'qb/payments/query.rb', aq + 'qb/payments/query.rb')
        template(aq + 'qb/payments/void.rb', aq + 'qb/payments/void.rb')
      end

      def routes_rb
         "config/routes.rb"
      end

      def copy_config
         template('config/qbwc.rb', "config/initializers/qbwc.rb")
      end

      def copy_controller 
         template('controllers/qbwc_controller.rb', "app/controllers/#{controller_name}_controller.rb")
      end

      def active_record
        migration_template 'db/migrate/create_qbwc_jobs.rb',     'db/migrate/create_qbwc_jobs.rb'
        migration_template 'db/migrate/create_qbwc_sessions.rb', 'db/migrate/create_qbwc_sessions.rb'
        migration_template 'db/migrate/index_qbwc_jobs.rb',      'db/migrate/index_qbwc_jobs.rb'
        migration_template 'db/migrate/change_request_index.rb', 'db/migrate/change_request_index.rb'
        migration_template 'db/migrate/session_pending_jobs_text.rb', 'db/migrate/session_pending_jobs_text.rb'
        migration_template 'db/migrate/add_qb_id_to_payments.rb', 'db/migrate/add_qb_id_to_payments.rb'
        migration_template 'db/migrate/add_qb_id_to_invoice_lines.rb', 'db/migrate/add_qb_id_to_invoice_lines.rb'
      end

      def self.next_migration_number(dirname)
        ::ActiveRecord::Generators::Base.next_migration_number(dirname)
      end

     def route1
        "wash_out :#{controller_name}"
     end

     def route2
        "get '#{controller_name}/qwc' => '#{controller_name}#qwc'"
     end

     def route3
        "get '#{controller_name}/action' => '#{controller_name}#_generate_wsdl'"
     end

     # Idempotent routes inspired by https://github.com/thoughtbot/administrate/issues/232
     # Idempotent routes fixed permanently by https://github.com/rails/rails/issues/22082
     def setup_routes
        route(route1) unless File.new(routes_rb).read.include?(route1)
        route(route2) unless File.new(routes_rb).read.include?(route2)
        route(route3) unless File.new(routes_rb).read.include?(route3)
      end
      
    end
  end
end
