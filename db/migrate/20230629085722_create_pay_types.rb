class CreatePayTypes < ActiveRecord::Migration[6.0]
  def up
    create_table :pay_types do |t|
      t.string :name, null: false
      t.integer :number, null: false, index: { unique: true }
    end

    pay_types = [{ name: 'Check',          number: 1 },
                 { name: 'Credit cart',    number: 2 },
                 { name: 'Purchase order', number: 3 }]

    PayType.create pay_types
  end

  def down
    drop_table :pay_types
  end
end
