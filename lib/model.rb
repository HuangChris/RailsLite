require_relative 'db_connection'
require_relative 'model_modules'
require 'active_support/inflector'
require 'byebug'

class SQLObject
  extend Searchable
  extend Associatable
  def self.columns
    records_and_columns = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
    records_and_columns.first.map{ |column| column.to_sym }
  end

  def self.finalize!

    self.columns.each do |column|
      define_method("#{column.to_s}") { self.attributes[column] }

      define_method("#{column.to_s}=") do |value|
        self.attributes[column] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.split(/(?=[A..Z])/).join("_").downcase + "s"
  end

  def self.all
    records = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
    self.parse_all(records)
  end

  def self.parse_all(results)
    results.map do |record|
      self.new(record)
    end
  end

  def self.find(id)
    records = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        id = #{id}
    SQL
    self.parse_all(records).first
  end

  def initialize(params = {})
    params.each do |key, value|
      unless self.class.columns.include?(key.to_sym)
        raise "unknown attribute '#{key}'"
      end
      attributes[key.to_sym] = value
    end
  end

  def attributes
    @attributes ||= Hash.new
  end

  def attribute_values
    @attributes.values
  end

  def insert
    column_names = self.class.columns.drop(1).map(&:to_s).join(", ")
    record = DBConnection.execute(<<-SQL, attributes)
      INSERT INTO
        #{self.class.table_name} (#{column_names})
      VALUES
        (#{self.class.columns.drop(1).map{|el| ":" + el.to_s }.join(", ")});
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    set_expression = self.class.columns.map do |column|
      column.to_s + "= :" + column.to_s
    end

    record = DBConnection.execute(<<-SQL, attributes)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_expression.join(", \n ") }
      WHERE
        id = #{self.id}
    SQL
  end

  def save
    self.id ? update : insert
  end
end
