class CreateSojournVisitors < ActiveRecord::Migration
  def change
    create_table :sojourn_visitors do |t|
      t.string :uuid, limit: 36, unique: true, null: false
      t.string :ip_address
      t.text :user_agent
      t.timestamp :created_at
    end
    add_index :sojourn_visitors, [:uuid]
  end
end
