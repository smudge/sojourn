class CreateSojournVisits < ActiveRecord::Migration
  def change
    create_table :sojourn_visits do |t|
      t.string :uuid, limit: 36, unique: true, null: false
      t.references :sojourn_visitor
      t.references :sojourn_campaign
      t.text :referrer, limit: 2048
      t.string :host, limit: 2048
      t.string :path, limit: 2048
      t.timestamp :created_at
      t.timestamp :last_active_at
    end
    add_index :sojourn_visits, [:sojourn_visitor_id]
    add_index :sojourn_visits, [:sojourn_campaign_id]
  end
end
