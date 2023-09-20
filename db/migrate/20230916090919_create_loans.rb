class CreateLoans < ActiveRecord::Migration[7.0]
  def change
    create_table :loans do |t|
      t.references :user, null: false, foreign_key: true
      t.references :admin, null: false, foreign_key: true
      t.decimal :amount
      t.string :state
      t.decimal :interest_rate

      t.timestamps
    end
  end
end
