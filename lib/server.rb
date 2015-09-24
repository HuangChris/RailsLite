require 'webrick'
require_relative 'router'
require_relative 'cats_controller'
router = Router.new
server = WEBrick::HTTPServer.new(Port: 3000)

#  require_relative '../app/routes.rb' #instead of making routes here
router.draw do
  get Regexp.new("^/cats$"), CatsController, :index
  post Regexp.new("^/cats$"), CatsController, :index
end

server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
