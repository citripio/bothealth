class AddSlugToFacebookPages < ActiveRecord::Migration[5.2]
  def change
    add_column :facebook_pages, :slug, :string, after: :name
    add_index :facebook_pages, :slug, unique: true
  end
end
