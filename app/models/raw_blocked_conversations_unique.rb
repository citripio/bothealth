class RawBlockedConversationsUnique < ApplicationRecord
  belongs_to :facebook_page
  default_scope { order(end_time: :asc) }
  scope :during, -> (start, finish) {
    where('end_time >= ? AND end_time <=?', start, finish)
  }

  def self.title
  	"Daily unique blocked conversations count"
  end

  def self.description
  	"Daily: The number of conversations with the Page that have been blocked."
  end
end
