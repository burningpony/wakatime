require 'uri'
require 'net/https'
require 'json'
require 'net/http/post/multipart'
require 'open-uri'
require 'cgi'

module Wakatime
  class Client
    def initialize(session)
      @session = session
    end

    def summary(start_at = Time.now - 86400 , end_at = Time.now )
      request_builder(:summary, {:start => start_at, :end => end_at})
    end

    def daily(start_at = Time.now - 86400 , end_at = Time.now )
      request_builder("summary/daily", {:start => start_at, :end => end_at})
    end

    def actions(start_at = Time.now - 86400 , end_at = Time.now )
      request_builder("actions", {:start => start_at, :end => end_at})
    end

    def plugins(start_at = Time.now - 86400 , end_at = Time.now )
      request_builder("plugins", {:start => start_at, :end => end_at})
    end

    def current_user
      request_builder("users/current")
    end

    def program_languages(params = {:show => "name"})
      request_builder("plugins", params)
    end

    private

    def cast_params(params)
      casted_params = params.inject({}) { |h, (k, v)| h[k] = cast_param(v); h }
    end

    def cast_param(param)
      case param.class.to_s
      when "Time"
        param.to_i
      else
        param
      end
    end

    def request_builder(action, params = {})
      uri  =  Addressable::URI.new
      uri.query_values = cast_params(params)

      url = "#{Wakatime::API_URL}/#{action}?#{uri.query}"
      @session.get( url )
    end
  end
end
