class Organization < ApplicationRecord
	has_and_belongs_to_many :users
	belongs_to :owner, foreign_key: :user_id, class_name: 'User'
	has_many :facebook_pages, dependent: :destroy
	extend FriendlyId
	friendly_id :slug_candidates, use: :slugged

	# Try building a slug based on the following fields in
	# increasing order of specificity.
	def slug_candidates
		ran = SecureRandom.random_number(34567)
		[
			[:title],
			[:title, ran],
		]
	end

	def self.hash_salt
		"this is my salt"
	end

	def self.hash_length
		16
	end

	def encoded_id
		require 'hashids'
		hashids = Hashids.new(Organization.hash_salt, Organization.hash_length)
    	hashids.encode(self.id)
	end

	def self.decode_id(hash)
		require 'hashids'
		hashids = Hashids.new(Organization.hash_salt, Organization.hash_length)
    	hashids.decode(hash)
	end
end
