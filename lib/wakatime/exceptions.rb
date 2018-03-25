module Wakatime
  class WakatimeError < StandardError
    attr_accessor :body, :status

    def initialize(error_json, status, body)
      @status = status
      @body = body
      @error_json = error_json
    end

    def [](key)
      @error_json[key]
    end

    def message
      [@error_json["errors"].join(" ")].join("\n")
    end
  end

  class AuthError < WakatimeError; end
  class RequestError < WakatimeError; end
  class ServerError < WakatimeError; end
end
