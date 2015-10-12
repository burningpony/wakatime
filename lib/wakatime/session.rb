module Wakatime
  class Session
    def initialize(opts = {}, backoff = 0.1)
      @backoff = backoff # try not to excessively hammer API.
      @api_key = opts[:api_key]
    end

    def get(url, raw = false)
      uri = URI.parse(url)
      request = Net::HTTP::Get.new(uri.request_uri)
      resp = request(uri, request, raw)
    end

    def request(uri, request, raw = false, _retries = 0)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      # http.set_debug_output($stdout)
      request.add_field('Content-Type', 'application/json')

      if @api_key
        request.add_field('Authorization', "Basic #{Base64.strict_encode64(@api_key)}") #
      end

      response = http.request(request)

      fail Wakatime::ObjectNotFound if response.is_a? Net::HTTPNotFound

      sleep(@backoff) # try not to excessively hammer API.

      handle_errors(response, raw)
    end

    def handle_errors(response, raw)
      status = response.code.to_i
      body = response.body
      begin
        parsed_body = JSON.parse(body)
      rescue
        msg = body.nil? || body.empty? ? 'no data returned' : body
        parsed_body = { 'errors' =>  msg }
      end
      # status is used to determine whether
      # we need to refresh the access token.
      parsed_body['status'] = status

      case status / 100
      when 3
        # 302 Found. We should return the url
        parsed_body['location'] = response['Location'] if status == 302
      when 4
        fail(Wakatime::AuthError.new(parsed_body, status, body), parsed_body['errors']) if status == 401
        fail(Wakatime::RequestError.new(parsed_body, status, body), parsed_body['errors'])
      when 5
        fail(Wakatime::ServerError.new(parsed_body, status, body), parsed_body['errors'])
      end
      raw ? body : parsed_body
    end
  end
end
