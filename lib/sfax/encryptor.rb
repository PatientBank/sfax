require 'openssl'
require 'base64'

module SFax
  class Encryptor

    def initialize(key, options = {})
      @key = key.clone
      @iv = options[:iv]
    end

    def encrypt(plain = nil, &block)
      Base64.urlsafe_encode64(cipher(plain, false, &block))
    end

    def decrypt(cipher_text = nil, &block)
      cipher(cipher_text, true, &block)
    end

    def <<(data)
      @data << @cipher.update(decode_if_needed(data))
    end

    private

    def decode_if_needed(data)
      @decrypt ? Base64.urlsafe_decode64(data) : data
    end

    def cipher(data = nil, decrypt = false, &block)
      @decrypt = decrypt
      @cipher = OpenSSL::Cipher::Cipher.new('aes-256-cbc')

      if @decrypt
        @cipher.decrypt
      else
        @cipher.encrypt
      end

      @cipher.key = @key
      @cipher.iv = @iv

      if block_given?
        @data = ''
        block.call self
      else
        @data = @cipher.update decode_if_needed(data) rescue nil
        @data = data if @data.nil?
      end

      @data << @cipher.final
      @data
    end
  end
end
