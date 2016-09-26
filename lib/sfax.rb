require 'sfax/connection'
require 'sfax/encryptor'
require 'sfax/path'
require 'sfax/version'
require 'faraday'
require 'json'

module SFax
  class Faxer

    def initialize(username = nil, api_key = nil, vector = nil, encryption_key = nil)
      return if username.nil? && api_key.nil? && vector.nil? && encryption_key.nil?
      @username = username
      @api_key = api_key
      @encryptor = SFax::Encryptor.new(encryption_key, iv: vector)
      @path = SFax::Path.new(encrypted_token, @api_key)
    end

    # Returns encrypted token for sending the fax.
    def encrypted_token
      raw = "Username=#{@username}&ApiKey=#{@api_key}&GenDT=#{Time.now.utc.iso8601}"
      @encryptor.encrypt(raw)
    end

    # Accepts the file to send and sends it to fax_number.
    def send_fax(fax_number, file, name = "")
      return if file.nil? || fax_number.nil?

      connection = SFax::Connection.outgoing
      fax = fax_number[-11..-1] || fax_number

      path = @path.send_fax(fax, name)
      response = connection.post path do |req|
        req.body = {}
        req.body['file'] = Faraday::UploadIO.new(open(file),
          'application/pdf', "#{Time.now.utc.iso8601}.pdf")
      end

      parsed = JSON.parse(response.body)
      fax_id = parsed
    end

    # Checks the status (Success, Failure etc.) of the fax with fax_id.
    def fax_status(fax_id)
      return if fax_id.nil?

      connection = SFax::Connection.incoming
      path = @path.fax_status(fax_id)
      response = connection.get path do |req|
        req.body = {}
      end

      parsed_response = JSON.parse(response.body)
      status_items = parsed_response['RecipientFaxStatusItems'] || []
      success_fax_id = status_items.first['SendFaxQueueId'] unless status_items.empty?
      is_success = parsed_response['isSuccess'] ? true : false
      return success_fax_id, is_success
    end

    # If there are any received faxes, returns an array of fax_ids for those faxes.
    def receive_fax(count)
      fax_count = (count > 500) ? 500 : count
      connection = SFax::Connection.incoming

      path = @path.receive_fax(fax_count.to_s)
      response = connection.get path do |req|
        req.body = {}
      end

      parsed = JSON.parse(response.body)
      has_more_items = parsed['Has_More_Items'] == 'true' ? true : false
      return has_more_items, parsed['InboundFaxItems']
    end

    # If a valid fax_id is received fetches the contents of the fax and returns
    def download_fax_as_pdf(fax_id)
      return if fax_id.nil?

      connection = SFax::Connection.incoming
      path = @path.download_fax_as_pdf(fax_id)
      response = connection.get path
      response.body
    end

    def download_fax_as_tif(fax_id)
      return if fax_id.nil?

      connection = SFax::Connection.incoming
      path = @path.download_fax_as_tif(fax_id)
      response = connection.get path
      response.body
    end
  end
end
