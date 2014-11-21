class CreateSojournRequests < ActiveRecord::Migration
  def change
    create_table :sojourn_requests do |t|
      t.references :sojourn_campaign
      t.references :sojourn_browser
      t.string :host, limit: 2048
      t.string :path, limit: 2048
      t.string :method
      t.string :controller
      t.string :action
      t.string :ip_address
      t.text :params
      t.text :referer
      t.timestamp :created_at
    end
    add_index :sojourn_requests, [:sojourn_campaign_id]
    add_index :sojourn_requests, [:sojourn_browser_id]
  end
end
