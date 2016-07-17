module SFax
  class Path

    def initialize(token, api_key)
      @token = token
      @api_key = api_key
    end

    def send_fax(fax, name)
      parts = [
        "sendfax?",
        "token=#{CGI.escape(@token)}",
        "ApiKey=#{CGI.escape(@api_key)}",
        "RecipientName=#{name}",
        "RecipientFax=#{fax}",
        "OptionalParams=&"
      ]
      '/api/' + parts.join('&')
    end

    def fax_status(fax_id)
      parts = [
        "sendfaxstatus?",
        "token=#{CGI.escape(@token)}",
        "ApiKey=#{CGI.escape(@api_key)}",
        "SendFaxQueueId=#{fax_id}"
      ]
      '/api/' + parts.join('&')
    end

    def receive_fax(count)
      parts = [
        "receiveinboundfax?",
        "token=#{CGI.escape(@token)}",
        "ApiKey=#{CGI.escape(@api_key)}",
        "MaxItems=#{count}"
      ]
      '/api/' + parts.join('&')
    end

    def download_fax_as_pdf(fax_id)
      parts = [
        "downloadinboundfaxaspdf?",
        "token=#{CGI.escape(@token)}",
        "ApiKey=#{CGI.escape(@api_key)}",
        "FaxId=#{fax_id}"
      ]
      '/api/' + parts.join('&')
    end

    def download_fax_as_tif(fax_id)
      parts = [
        "downloadinboundfaxastif?",
        "token=#{CGI.escape(@token)}",
        "ApiKey=#{CGI.escape(@api_key)}",
        "FaxId=#{fax_id}"
      ]
      '/api/' + parts.join('&')
    end
  end
end
