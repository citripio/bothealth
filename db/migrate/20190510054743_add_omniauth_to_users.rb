class AddOmniauthToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :provider, :string, after: :email
    add_column :users, :uid, :string, after: :provider
  end
end
