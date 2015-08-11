require 'faraday'

module SFax
  class Connection
    
    def self.incoming
      Faraday.new(url: 'https://api.sfaxme.com') do |faraday|
        faraday.request :url_encoded
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
      end
    end

    def self.outgoing
      Faraday.new(url: 'https://api.sfaxme.com') do |faraday|
        faraday.request :multipart
        faraday.request :url_encoded
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
