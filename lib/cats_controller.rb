require 'byebug'
require_relative 'controller_base'
class CatsController < ControllerBase
  protect_from_forgery
  def index
    @cats = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        cats
    SQL
  render :index
  end
end
