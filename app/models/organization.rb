class Organization < ApplicationRecord
	has_and_belongs_to_many :users
	has_many :facebook_pages

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
