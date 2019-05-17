json.extract! facebook_page, :id, :name, :access_token, :organization_id, :created_at, :updated_at
json.url facebook_page_url(facebook_page, format: :json)
