module Searchable
  def where(params)
    p params
    if params.is_a?(Hash)
      columns = []
      values = []
      params.each do |key, value|
        columns << key.to_s + " = ?"
        values << value
      end
    end
      records = DBConnection.execute(<<-SQL, values)
        SELECT
          *
        FROM
          #{self.table_name}
        WHERE
          #{columns.join(" AND ")}
      SQL
      self.parse_all(records)
  end
end

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = options[:foreign_key] || (name.to_s + "_id").to_sym
    @class_name = options[:class_name] || name.to_s.capitalize
    @primary_key = options[:primary_key] || :id
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = options[:foreign_key] || (self_class_name.downcase + "_id").to_sym
    @class_name = options[:class_name] || name.to_s.capitalize[0...-1]
    @primary_key = options[:primary_key] || :id
  end
end

module Associatable
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    assoc_options[name] = options
    define_method(name) do
      f_key = self.send(options.foreign_key)
      table = options.table_name
      p_key = options.primary_key

      options.model_class.where(p_key => f_key).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)
    assoc_options[name] = options
    define_method(name) do
      f_key = options.foreign_key
      table = options.table_name
      p_key = self.send(options.primary_key)

      options.model_class.where(f_key => p_key)
    end
  end

  def assoc_options
    @options ||= {}
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      source_table = source_options.table_name
      through_table = through_options.table_name

      record = DBConnection.execute(<<-SQL)
        SELECT
          #{source_table}.*
        FROM
          #{source_table}
        JOIN
          #{through_table}
          ON #{source_table}.#{source_options.primary_key} =
           #{through_table}.#{source_options.foreign_key}
        WHERE
          #{through_table}.#{through_options.primary_key} =
           #{self.send(through_options.foreign_key)}
      SQL

      source_options.model_class.parse_all(record).first
    end
  end

  def has_many_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      source_table = source_options.table_name #cats
      through_table = through_options.table_name #humans

      record = DBConnection.execute(<<-SQL)
        SELECT
          #{source_table}.*
        FROM
          #{source_table}
        JOIN
          #{through_table}
          ON #{source_table}.#{source_options.foreign_key} =
           #{through_table}.#{source_options.primary_key}
        WHERE
          #{through_table}.#{through_options.foreign_key} =
           #{self.send(through_options.primary_key)}
      SQL

      source_options.model_class.parse_all(record)
    end
  end
end
