class CreateRawReportedConversationsUniques < ActiveRecord::Migration[5.2]
  def change
    create_table :raw_reported_conversations_uniques do |t|
      t.integer :value
      t.datetime :end_time
      t.references :facebook_page, foreign_key: true

      t.timestamps
    end
  end
end
