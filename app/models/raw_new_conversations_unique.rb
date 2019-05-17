class RawNewConversationsUnique < ApplicationRecord
  belongs_to :facebook_page
  default_scope { order(end_time: :asc) }
  scope :during, -> (start, finish) {
    where('end_time >= ? AND end_time <=?', start, finish)
  }

  def self.title
  	"Daily unique new conversations count"
  end

  def self.description
  	"Daily: The number of messaging conversations on Facebook Messenger that began with people who had never messaged with your business before."
  end
end
