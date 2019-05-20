class FacebookPage < ApplicationRecord
	belongs_to :organization
	has_many :raw_total_messaging_connections, dependent: :destroy
	has_many :raw_new_conversations_unique, dependent: :destroy
	has_many :raw_blocked_conversations_unique, dependent: :destroy
	has_many :raw_reported_conversations_unique, dependent: :destroy
	has_many :raw_feedback_by_action_unique, dependent: :destroy
	after_create :fetch_raw_data

	def format_for_chart(name, field, start_date, end_date)
		self.public_send(name).during(start_date, end_date).pluck(field)
	end

	def new_conversations(start_date, end_date)
		self.raw_new_conversations_unique.during(start_date, end_date).map(&:value).sum
	end

	def blocked_conversations(start_date, end_date)
		self.raw_blocked_conversations_unique.during(start_date, end_date).map(&:value).sum
	end

	def reported_conversations(start_date, end_date)
		self.raw_reported_conversations_unique.during(start_date, end_date).map(&:value).sum
	end

	def total_conversations(start_date, end_date)
		result = self.raw_total_messaging_connections.during(start_date, end_date)
		if result.length > 0
			result.last.value
		else
			0
		end
	end

	def fetch_raw_data
		page_graph = Koala::Facebook::API.new(self.access_token)
		since = (Time.now - 1.year).to_i
		metric = %w(
			page_messages_total_messaging_connections
			page_messages_new_conversations_unique
			page_messages_blocked_conversations_unique
			page_messages_reported_conversations_unique
			page_messages_feedback_by_action_unique
		)
		insights = page_graph.get_object("me/insights?metric=#{metric.join(",")}&since=#{since}")
		insights.each do |insight|
			class_name = ""
			case insight["name"]
				when "page_messages_total_messaging_connections"
					class_name = "RawTotalMessagingConnection"
				when "page_messages_new_conversations_unique"
					class_name = "RawNewConversationsUnique"
				when "page_messages_blocked_conversations_unique"
					class_name = "RawBlockedConversationsUnique"
				when "page_messages_reported_conversations_unique"
					class_name = "RawReportedConversationsUnique"
				when "page_messages_feedback_by_action_unique"
					class_name = "RawFeedbackByActionUnique"
			end
			insight["values"].each do |data|
				row = class_name.constantize.find_or_initialize_by(
					facebook_page_id: self.id,
					end_time: data["end_time"]
				)
				row.value = data["value"]
				row.save
			end
		end
	end
end
