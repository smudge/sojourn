class CreateSojournBrowsers < ActiveRecord::Migration
  def change
    create_table :sojourn_browsers do |t|
      t.text :user_agent, unique: true
      t.string :name
      t.string :version
      t.string :platform
      t.boolean :known
      t.boolean :bot
    end
    add_index :sojourn_browsers, [:user_agent]
  end
end
