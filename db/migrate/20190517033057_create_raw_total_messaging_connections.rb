class CreateRawTotalMessagingConnections < ActiveRecord::Migration[5.2]
  def change
    create_table :raw_total_messaging_connections do |t|
      t.integer :value
      t.datetime :end_time
      t.references :facebook_page, foreign_key: true

      t.timestamps
    end
  end
end
