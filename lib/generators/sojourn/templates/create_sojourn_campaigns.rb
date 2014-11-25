class CreateSojournCampaigns < ActiveRecord::Migration
  def change
    create_table :sojourn_campaigns do |t|
      t.string :path, limit: 2048
      t.string :params, limit: 2048
      t.timestamp :created_at
    end
    add_index :sojourn_campaigns, [:path, :params]
  end
end
