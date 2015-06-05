class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :caller
      t.string :body
      t.string :status

      t.timestamps null: false
    end
  end
end
