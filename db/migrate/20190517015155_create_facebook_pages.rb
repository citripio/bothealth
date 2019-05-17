class CreateFacebookPages < ActiveRecord::Migration[5.2]
  def change
    create_table :facebook_pages do |t|
   	  t.string :identifier
      t.string :name
      t.string :access_token
      t.references :organization, foreign_key: true

      t.timestamps

    end
    
    add_index :facebook_pages, :identifier, unique: true
  end
end
