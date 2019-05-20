class AddUserToFacebookPages < ActiveRecord::Migration[5.2]
  def change
    add_reference :facebook_pages, :user, after: :access_token, foreign_key: true
  end
end
