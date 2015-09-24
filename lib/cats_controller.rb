require 'byebug'
require_relative 'controller_base'

require_relative 'cat'
class CatsController < ControllerBase
  protect_from_forgery
  def index
    @cats = Cat.all
    # DBConnection.execute(<<-SQL)
    #   SELECT
    #     *
    #   FROM
    #     cats
    # SQL
  render :index
  end
end
