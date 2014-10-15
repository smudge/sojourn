class CreateSojournVisits < ActiveRecord::Migration
  def change
    create_table :sojourn_visits do |t|
      t.string :uuid, limit: 36, unique: true, null: false
      t.references :sojourn_visitor
      t.text :referrer
      t.string :host
      t.string :path
      t.string :utm_source
      t.string :utm_medium
      t.string :utm_term
      t.string :utm_content
      t.string :utm_campaign
      t.timestamps
    end
    add_index :sojourn_visits, [:sojourn_visitor_id]
  end
end
