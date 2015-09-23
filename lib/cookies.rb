require 'json'
require 'webrick'
class Session

  def initialize(req)
    cookie = req.cookies[0]
    # I'm not sure this works: I might need to rename and find by name
    # cookie = req.cookies.select { |cookie| cookie.name = "_rails_lite_app_flash"}
    if cookie
      @session = JSON.parse(cookie.value)
    else
      @session = {}
    end
  end

  def to_s
    @session.to_s
  end

  def [](key)
    @session[key]
  end

  def []=(key, val)
    @session[key] = val
  end

  def store_session(res)
    res.cookies[0] = WEBrick::Cookie.new("_rails_lite_app", @session.to_json)
  end
end

class Flash
  def initialize(req)
    cookie = req.cookies[1]
    cookie ? @flash= JSON.parse(cookie.value) : @flash = {}
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

  def to_s
    hash = @flash.dup
    hash["now"]=@new_flash
    hash
 end

  def store_flash(res)
    res.cookies[1] = WEBrick::Cookie.new("_rails_lite_app", @new_flash.to_json)
  end
end
