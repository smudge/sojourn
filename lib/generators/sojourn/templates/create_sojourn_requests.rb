class CreateSojournRequests < ActiveRecord::Migration
  def change
    create_table :sojourn_requests do |t|
      t.references :sojourn_campaign
      t.string :host, limit: 2048
      t.string :path, limit: 2048
      t.string :method
      t.string :ip_address
      t.text :params
      t.text :referer
      t.text :user_agent
      t.timestamp :created_at
    end
    add_index :sojourn_requests, [:sojourn_campaign_id]
  end
end
