class CreateHoldings < ActiveRecord::Migration[6.0]
  def change
    create_table :holdings do |t|
      t.string :cusip, null: false
      t.string :description, null: false
      t.float :par_value, null: false
      t.float :coupon, null: false
      t.integer :maturity, null: false
      t.string :sector, null: false
      t.string :quality, null: false
      t.decimal :price, null: false
      t.float :accrued, null: false
      t.string :currency, null: false
      t.decimal :market_value, null: false
      t.float :weight, null: false
      t.float :yield, null: false
      t.float :dur, null: false
      t.float :cov, null: false
      t.float :oas, null: false
      t.float :sprd_dur, null: false
      t.float :pd, null: false

      t.timestamps
    end
  end
end
