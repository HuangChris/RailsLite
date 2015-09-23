require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/core_ext'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      raise "already rendered" if already_built_response?
      folder = self.class.name.split /(?=[A-Z])/
      folder = folder.map(&:downcase).join("_")
      template = File.read("views/#{folder}/#{template_name}.html.erb")
      res.body = ERB.new(template).result
      res.content_type = "text/html"
      @built_response = true
    end
  end

    def special_method
      "Test string here"
    end
end
include(Phase3)
