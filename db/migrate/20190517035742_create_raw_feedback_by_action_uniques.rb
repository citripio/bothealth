class CreateRawFeedbackByActionUniques < ActiveRecord::Migration[5.2]
  def change
    create_table :raw_feedback_by_action_uniques do |t|
      t.json :value
      t.datetime :end_time
      t.references :facebook_page, foreign_key: true

      t.timestamps
    end
  end
end
