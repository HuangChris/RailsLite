require 'json'
require 'webrick'

class Flash
  def initialize
    cookie = req.cookies[1]
    if cookie
      @flash= JSON.parse(cookie.value)
    else
      @flash = {}
    end
    @new_flash = {}
  end

  def [](key)
    @flash[key]
  end

  def []=(key,value)
    @new_flash[key] = value
  end

  def.now[]=(key,value)
    @flash[key] = value
  end

  def store_flash(res)
    res.cookies[1] WEBrick::Cookie.new("_rails_lite_app", @new_flash.to_json)
  end
end

class Session
  def store_session(res)
    res.cookies[0] = WEBrick::Cookie.new("_rails_lite_app", @session.to_json)
  end
end
