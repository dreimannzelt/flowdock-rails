require "flowdock/rails/version"
require "flowdock"
require "json"

module Flowdock
  module Rails
    extend ActiveSupport::Concern

    module ClassMethods
      def flow
        api_token = (ENV["FLOWDOCK_RAILS_API_TOKEN"].try(:split, ",") || []).map(&:strip)
        @flow ||= Flowdock::Flow.new(
          flowdock_rails_options.reverse_merge(
            api_token: api_token,
            source: "Flowdock Notifier",
            project: ( ENV["FLOWDOCK_RAILS_NAME"] || ::Rails.application.class.parent_name ).parameterize,
            from: {
              name: ( ENV["FLOWDOCK_RAILS_FROM_NAME"] || "Marv" ),
              address: ( ENV["FLOWDOCK_RAILS_FROM_EMAIL"] || "marv@dreimannzelt.de")
            }
          )
        )
      end

      def push_to_flow_enabled?
        ( !::Rails.env.test? ) &&
        (
          ( ENV["FLOWDOCK_RAILS_ENABLED"] == "true" ) ||
          ( !(ENV["FLOWDOCK_RAILS_ENABLED"] == "false") && ::Rails.env.production? )
        )
      end

      def push_to_flow(options = {})
        begin
          if push_to_flow_enabled?
            flow.push_to_team_inbox(options)
          else
            logger.info "[Flowdock::Rails] Notification is disabled"
          end
        rescue Exception => e
          logger.fatal "[Flowdock::Rails] Something went wrong with pushing to the flow:"
          logger.fatal "[Flowdock::Rails] #{e}"
        end
      end

      def notify_flow(options = {})
        cattr_accessor :flowdock_rails_options
        self.flowdock_rails_options = options

        after_create :push_create_notification_to_flow
        after_update :push_update_notification_to_flow
      end
    end

    private

    def formatted_attributes_for_flow(hash, changes=false)
      case ENV["FLOWDOCK_RAILS_FORMAT"]
      when "json"
        "<pre>#{ JSON.pretty_generate(hash) }</pre>"
      else
        if hash.any?
          %Q{
            <table class="diff">
              <tbody>
                #{ hash.map{|k,v| "<tr><th>#{k}</th><td>#{changes ? v.first : v}</td><td>#{changes ? v.last : ""}</td></tr>" }.join("\n") }
              </tbody>
            </table>
          }.strip
        else
          "<pre>Nothing to show!</pre>"
        end
      end
    end

    def push_create_notification_to_flow
      self.class.push_to_flow(
        subject: "#{self.class.model_name.human} created",
        content: %Q{
          <h2>#{self.class.model_name.human} created</h2>
          <h3>Attributes</h3>
          #{formatted_attributes_for_flow self.attributes}
        },
        tags: [self.class.model_name.param_key, "resource", "created", ::Rails.env]
      )
    end

    def push_update_notification_to_flow
      self.class.push_to_flow(
        subject: "#{self.class.model_name.human} updated",
        content: %Q{
          <h2>#{self.class.model_name.human} updated</h2>
          <h3>Changes</h3>
          #{formatted_attributes_for_flow self.changes, true}
          <h3>Attributes</h3>
          #{formatted_attributes_for_flow self.attributes}
        },
        tags: [self.class.model_name.param_key, "resource", "updated", ::Rails.env]
      )
    end
  end
end

ActiveRecord::Base.send :include, Flowdock::Rails
