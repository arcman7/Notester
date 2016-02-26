module CategoryHelper
  def decode_utf8_b64(string)
    URI.unescape(CGI::escape(Base64.decode64(string)))
  end
end