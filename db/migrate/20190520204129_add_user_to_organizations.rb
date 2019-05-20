class AddUserToOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_reference :organizations, :user, after: :slug, foreign_key: true
  end
end
