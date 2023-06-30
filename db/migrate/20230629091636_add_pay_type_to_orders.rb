class AddPayTypeToOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :pay_type, :integer
    add_reference :orders, :pay_type, null: true, foreign_key: true
  end
end
