#!/usr/bin/env ruby

require "sinatra"
require "openssl"
require "base64"

configure do
  enable :inline_templates
end

helpers do
  include ERB::Util
end

set :environment, :production

KEY = ["c12b9b9ef2e6ed9441aaaa6914f5f001"].pack("H*")

def encrypt(plaintext)
  plaintext += "\x00" until plaintext.bytesize % 16 == 0
  cipher = OpenSSL::Cipher::Cipher.new("aes-128-ecb")
  cipher.encrypt
  cipher.key = KEY
  cipher.padding = 0
  ciphertext = cipher.update(plaintext) << cipher.final
  return ciphertext.unpack('H*')[0]
end

def decrypt(hex_ciphertext)
  ciphertext = [hex_ciphertext].pack('H*')
  cipher = OpenSSL::Cipher::Cipher.new("aes-128-ecb")
  cipher.decrypt
  cipher.key = KEY
  cipher.padding = 0
  plaintext = cipher.update(ciphertext) << cipher.final
  plaintext.gsub!(/\0+\z/,"")
  return plaintext.chomp("\x00")
end

get "/" do
  @title = "Number Guessing Game"
  erb :index
end

post "/guess" do
  if params["guess_num"] == "8"
    msg = "Congratulations! 8 is the correct number."
  else
    msg = "#{params["guess_num"]} is the incorrect number."
  end
  encrypted_msg = encrypt(msg)
  redirect to("/result?msg=#{encrypted_msg}")
end

get "/result" do
  @msg = decrypt(params["msg"])
  if @msg =~ /\ACongratulations! [^8] is the correct number\.\z/
    @msg += "\nThe flag is libctf{ecb_mode_blocks_are_independent}"
  end
  erb :result
end


__END__

@@ layout
<!doctype html>
<html>
 <head>
  <title><%= h @title %></title>
 </head>
 <body>
  <h1><%= h @title %></h1>
<%= yield %>
 </body>
</html>

@@ index
<h2>Guess a number between 1 and 10:</h2>
<form action="/guess" method="post">
 Number: <input type="text" name="guess_num" /><br />
 <input type="submit" value="Guess" />
</form>

@@ result
<h2><%= h @msg %></h2>
