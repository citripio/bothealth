class AddSlugToOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :slug, :string, after: :title
    add_index :organizations, :slug, unique: true
  end
end
