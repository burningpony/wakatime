require 'uri'
require 'net/https'
require 'json'
require 'net/http/post/multipart'
require 'open-uri'
require 'cgi'
require 'active_support/inflector'
require 'addressable/template'
require 'base64'
module Wakatime
  class Client
    def initialize(session)
      @session = session
    end

    def summaries(start_at = Time.now - 86_400, end_at = Time.now)
      request_builder('summaries', start: start_at, end: end_at)
    end

    def durations(date = Date.today)
      request_builder('durations', date: date)
    end

    def heartbeats(params = {})
      params[:date] ||= Date.today
      params[:show] ||= 'file,branch,project,time'

      request_builder('heartbeats', params)
    end

    def plugins(params = {})
      params[:show] ||= 'name,version'
      request_builder('plugins', params)
    end

    def current_user(params = {})
      params[:show] ||= 'email,timeout,last_plugin,timezone'
      request_builder('users/current', params)
    end

    private

    def cast_params(params)
      params.reduce({}) { |h, (k, v)| h[k] = cast_param(v); h }
    end

    def cast_param(param)
      case param.class.to_s
      when 'Time'
        param.to_i
      else
        param
      end
    end

    def request_builder(action, params = {}, raw = false)
      uri  = Addressable::Template.new("#{Wakatime::API_URL}/#{action}{?query*}")
      uri  = uri.expand(
        'query' => cast_params(params)
      )

      response = @session.get(uri.to_s)

      if raw
        response
      else
        response_factory(action, response)
      end
    end

    def response_factory(action, response)
      klass = Object.const_get("Wakatime::Models::#{action.split('/').first.singularize.classify}")

      if response['data'].is_a? Hash
        klass.new(response['data'])
      else
        response['data'].map do |attributes|
          klass.new(attributes)
        end
      end
    end
  end
end
