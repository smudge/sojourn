class CreateSojournEvents < ActiveRecord::Migration
  def change
    create_table :sojourn_events do |t|
      t.string :sojourner_uuid, limit: 36, null: false
      t.string :name
      t.text :properties
      t.references :sojourn_request
      t.references :user
      t.timestamp :created_at
    end
    add_index :sojourn_events, [:sojourner_uuid]
    add_index :sojourn_events, [:sojourn_request_id]
    add_index :sojourn_events, [:user_id]
    add_index :sojourn_events, [:created_at]
    add_index :sojourn_events, [:name]
  end
end
