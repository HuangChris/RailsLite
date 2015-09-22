
require 'webrick'
require 'JSON'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html

server = WEBrick::HTTPServer.new(:Port => 3000)
trap('INT') { server.shutdown }
server.mount_proc("/") do |request, response|
  response.content_type = "text/text"
  path = request.to_json.split( )[1]
  response.body = path
end

server.start
