class RawReportedConversationsUnique < ApplicationRecord
  belongs_to :facebook_page
  default_scope { order(end_time: :asc) }
  scope :during, -> (start, finish) {
    where('end_time >= ? AND end_time <=?', start, finish)
  }

  def self.title
  	"Daily unique reported conversations count"
  end

  def self.description
  	"Daily: The number of conversations from your Page that have been reported by people for reasons such as spam, or containing inappropriate content."
  end
end
