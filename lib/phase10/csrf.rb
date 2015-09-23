class ControllerBase < Phase9::ControllerBase
  protect_from_forgery true
  helper_method :form_authenticity_token

  def intialize(req, res, route_params = {})
    super(req, res, route_params = {})
    check_authenticity if @@protect_from_forgery
  end
  #Why do we need this?
  # def helper_method(method_name)
  #   ViewHelper.define_method(method_name) {instance_method(method_name)}
  #   #might need to create a "define method" in ViewHelper module, that takes
  #   #method name and controller object
  # end

  def protect_from_forgery(boolean)
    @@protect_from_forgery == boolean
  end

  def check_authenticity
    unless req.method == "GET" ||
      params[authenticity_token] == session[authenticity_token]
        raise "Unauthenticated request"
      end
    end
    session[authenticity_token] = SecureRandom.urlsafe_base64
  end

  def form_authenticity_token
    session[authenticity_token]
  end
end
