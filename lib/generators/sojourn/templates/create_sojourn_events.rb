class CreateSojournEvents < ActiveRecord::Migration
  def change
    create_table :sojourn_events do |t|
      t.string :name
      t.text :properties
      t.references :sojourn_visit
      t.timestamp :created_at
    end
    add_index :sojourn_events, [:sojourn_visit_id]
    add_index :sojourn_events, [:name]
  end
end