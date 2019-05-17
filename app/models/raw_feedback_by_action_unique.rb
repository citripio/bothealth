class RawFeedbackByActionUnique < ApplicationRecord
  belongs_to :facebook_page
  default_scope { order(end_time: :asc) }
  scope :during, -> (start, finish) {
    where('end_time >= ? AND end_time <=?', start, finish)
  }

  def self.title
  	"Daily unique conversation count broken down by user feedback actions"
  end

  def self.description
  	"Daily: unique conversation count per page broken down by user feedback actions."
  end
end
