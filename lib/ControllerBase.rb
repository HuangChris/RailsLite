class ControllerBase
  attr_reader :req, :res, :params
  #options you would add to your ApplicationController/modelcontroller
  # protect_from_forgery true
  # helper_method :form_authenticity_token

  def self.protect_from_forgery(boolean)
    @@protect_from_forgery == boolean
  end

  def form_authenticity_token
    session[authenticity_token]
  end

  # setup the controller
  def initialize(req, res, route_params = {})
    @req, @res = req, res
    @params = Params.new(req, route_params)
    check_authenticity if @@protect_from_forgery
  end

  def check_authenticity
    unless req.request_method == "GET" ||
      params[authenticity_token] == session[authenticity_token]
        raise "Unauthenticated request"
    end
    session[authenticity_token] = SecureRandom.urlsafe_base64
  end

  def invoke_action(name)
    self.send(name)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @built_response
  end

  def render(template_name)
    raise "already rendered" if already_built_response?
    folder = self.class.name.split /(?=[A-Z])/
    folder = folder.map(&:downcase).join("_")
    template = File.read("views/#{folder}/#{template_name}.html.erb")
    res.body = ERB.new(template).result
    res.content_type = "text/html"
    @built_response = true
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||=Flash.new(req)
  end

  # Set the response status code and header
  def redirect_to(url)
    session.store_session(res)
    flash.store_flash(res)
    raise 'Already set response' if already_built_response?
    res.status=(302)
    res["location"] = url
    # p res
    @built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    session.store_session(res)
    flash.store_flash(res)
    raise 'Already set response' if already_built_response?
    res.content_type = content_type
    res.body = content
    @built_response = true

  end

  #Why do we need this?
  #Because ERB.new evaluates expressions in the main namespace
  def helper_method(method_name)
    # ViewHelper.define_method(method_name) {instance_method(method_name)}
    #might need to create a "define method" in ViewHelper module, that takes
    #method name and controller object
    ViewHelper::make_helper_method(method_name, self) {instance_method(method_name)}
  end
end
