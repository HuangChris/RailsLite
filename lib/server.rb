require 'webrick'
require_relative 'router'
require_relative 'cats_controller'
router = Router.new
server = WEBrick::HTTPServer.new(Port: 3000)
router.draw do
  get Regexp.new("^/cats$"), CatsController, :index
end

server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
