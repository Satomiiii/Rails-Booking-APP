class CreateReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :reservations do |t|
      t.date :check_in
      #t.date :check_out
      t.integer :nights
      t.integer :guests
      t.integer :total_amount
      t.datetime :confirmed_at
      #t.datetime :check_in
      t.datetime :check_out
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end





  

  