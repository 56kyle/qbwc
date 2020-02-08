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

      def actions
        %W(Add, Mod, Del, Query, Void)
      end

      def qb
        "quickbooks/"
      end

      def _w
        "t2qb/"
      end

      def _e
        %W(company, invoice, invoice_line, payment).map!{|qb_entity| "qb_#{qb_entity}"}
      end

      def make_quickbooks_directories
        _e.map!{|entity| "#{qb}#{_w}#{entity}"}.each do |ent|
          directory(ent)
        end
      end

      def copy_under_quickbooks
        qb_files = %W(qb_hook, qb_util, t2qb, qb_worker_util).map!{|file| "#{file}.rb"}
        qb_files.each do |qb_file|
          qb_input = qb(qb_file)
          template(qb_input, qb_input)
        end
      end

      def make_qb_worker_directories
        qb(_w(_e)).each do |qb_w_e_directory|
          directory(qb_w_e_directory)
        end
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
