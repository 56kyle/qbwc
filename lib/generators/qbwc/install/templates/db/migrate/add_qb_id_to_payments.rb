class AddQbIdToPayments < ActiveRecord::Migration[5.0]
  def change
    add_column :payments, :qb_id, :string
  end
end
