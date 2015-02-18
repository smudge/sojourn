class CreateSojournCampaigns < ActiveRecord::Migration
  def change
    create_table :sojourn_campaigns do |t|
      t.string :params, limit: 2048
      t.timestamp :created_at
    end
    add_index :sojourn_campaigns, :params
  end
end
