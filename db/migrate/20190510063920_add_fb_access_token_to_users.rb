class AddFbAccessTokenToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :fb_access_token, :string, after: :uid
  end
end
