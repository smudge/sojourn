class CreateSojournVisitors < ActiveRecord::Migration
  def change
    create_table :sojourn_visitors do |t|
      t.string :uuid, limit: 36, unique: true, null: false
      t.string :ip_address
      t.text :user_agent
      t.references :user
      t.timestamps
    end
    add_index :sojourn_visitors, [:user_id]
  end
end
