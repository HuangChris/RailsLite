require 'webrick'
require_relative 'controller_base'
require_relative 'router'
router = Router.new
server = WEBrick::HTTPServer.new(Port: 3000)

server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
