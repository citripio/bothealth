class RawTotalMessagingConnection < ApplicationRecord
  belongs_to :facebook_page
  default_scope { order(end_time: :asc) }
  scope :during, -> (start, finish) {
    where('end_time >= ? AND end_time <=?', start, finish)
  }

  def self.title
  	"Messaging connections"
  end

  def self.description
  	"Daily: The number of people your business can send messages to."
  end
end
