class AddQbIdToInvoiceLines < ActiveRecord::Migration[5.0]
  def change
    add_column :invoice_lines, :qb_id, :string
  end
end
