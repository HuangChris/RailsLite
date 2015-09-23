module ViewHelper
  def make_helper_method(name, controller, &prc)
    define_method(:name) { controller.call(prc) }
  end
end
