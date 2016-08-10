require "ruboty/minecraft_switch/version"
require "net/http"
require "uri"

module Ruboty
  module Actions
    class MinecraftSwitchOn < Ruboty::Actions::Base
      def call
        log_tweet
        start_minecraft_server
      end

      private

      def endpoint_url
        URI.parse(ENV.fetch('ENDPOINT_URL'))
      end

      def log_tweet
        Ruboty.logger.info(message.original.fetch(:tweet).to_h.to_json)
      end

      def start_minecraft_server
        req = Net::HTTP::Post.new(endpoint_url)
        req['x-api-key'] = x_api_key
        res = Net::HTTP.start(endpoint_url.host, use_ssl: true) do |http|
          http.request(req)
        end

        Ruboty.logger.info(code: res.code, body: res.body)

        message.reply(res.body)
      rescue => e
        Ruboty.logger.error(e.message)
        Ruboty.logger.error(e.backtrace.join("\n"))
      end

      def x_api_key
        ENV.fetch('X_API_KEY')
      end
    end
  end

  module Handlers
    class MinecraftSwitch < Ruboty::Handlers::Base
      on /.*/, name: 'switch_on', description: 'minecraft server switch on'

      def switch_on(message)
        Ruboty::Actions::MinecraftSwitchOn.new(message).call
      end
    end
  end
end
