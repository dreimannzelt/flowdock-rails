require "flowdock/rails/version"
require "flowdock"

module Flowdock
  module Rails
    extend ActiveSupport::Concern

    included do
      def push_create_notification_to_flow
        self.class.flow.push_to_team_inbox(
          subject: "#{self.class.model_name.human} created",
          content: %Q{
            <h2>#{self.class.model_name.human} created</h2>
            <blockquote>
              #{self.inspect}
            </blockquote>
          },
          tags: [self.class.model_name.param_key, "resource", "created"]
        )
      end

      def push_update_notification_to_flow
        self.class.flow.push_to_team_inbox(
          subject: "#{self.class.model_name.human} updated",
          content: %Q{
            <h2>#{self.class.model_name.human} updated</h2>
            <blockquote>
              #{self.changes}
            </blockquote>
          },
          tags: [self.class.model_name.param_key, "resource", "updated"]
        )
      end
    end

    module ClassMethods
      def flow
        api_token = (ENV["FLOWDOCK_RAILS_API_TOKEN"].try(:split, ",") || []).map(&:strip)

        @flow ||= Flowdock::Flow.new(
          flowdock_rails_options.reverse_merge(
            api_token: api_token,
            source: "Flowdock Notifier",
            from: {
              name: "Marv",
              address: "marv@dreimannzelt.de"
            }
          )
        )
      end

      def notify_flow(options = {})
        cattr_accessor :flowdock_rails_options
        self.flowdock_rails_options = options

        after_create :push_create_notification_to_flow
        after_update :push_update_notification_to_flow
      end
    end

  end
end

ActiveRecord::Base.send :include, Flowdock::Rails
