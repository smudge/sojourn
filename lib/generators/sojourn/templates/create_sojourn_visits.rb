class CreateSojournVisits < ActiveRecord::Migration
  def change
    create_table :sojourn_visits do |t|
      t.string :uuid, limit: 36, unique: true, null: false
      t.references :sojourn_visitor
      t.references :sojourn_campaign
      t.text :referrer
      t.string :host
      t.string :path
      t.timestamp :created_at
      t.timestamp :last_active_at
    end
    add_index :sojourn_visits, [:sojourn_visitor_id]
    add_index :sojourn_visits, [:sojourn_campaign_id]
  end
end
