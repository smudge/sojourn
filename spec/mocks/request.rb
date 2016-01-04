require 'securerandom'

module Mocks
  class Request
    CHROME_UA = <<-EOF.squish
        Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko)
          Chrome/41.0.2228.0 Safari/537.36
      EOF

    attr_reader :opts

    def initialize(opts = {})
      @opts = opts
    end

    def uuid
      opts[:uuid] || SecureRandom.uuid
    end

    def referer
      opts[:referer]
    end

    def host
      opts[:host] || 'http://example.com'
    end

    def path
      opts[:path] || '/'
    end

    def params
      opts[:params] || {}.with_indifferent_access
    end

    def method
      opts[:method] || 'GET'
    end

    def filtered_parameters
      @filtered_parameters ||= params.merge(filtered: true)
    end

    def request_method_symbol
      @request_method_symbol ||= method.downcase.to_sym
    end

    def remote_ip
      opts[:remote_ip] || '192.168.1.1'
    end

    def user_agent
      opts[:user_agent] || CHROME_UA
    end
  end
end
