require 'byebug'
require_relative 'controller_base'
class CatsController < ControllerBase
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
