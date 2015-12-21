class CreateSojournRequests < ActiveRecord::Migration
  def change
    create_table :sojourn_requests do |t|
      t.string :host, limit: 2048
      t.string :path, limit: 2048
      t.string :method
      t.string :controller
      t.string :action
      t.string :ip_address
      t.text :user_agent
      t.text :params
      t.text :referer
      t.timestamp :created_at
    end
  end
end
