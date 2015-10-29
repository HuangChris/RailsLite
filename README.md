#Rails Lite
  * Functional MVC framework, capable of database queries and rendering HTML
  on HTTP requests.

##Steps to run a basic webapp:

* Make your database (cats.db and cats.sql)
  * You can rename them if you like, but change the names in db_connection.rb
* write routes in app/routes.rb
  * for now, they have to be written directly on the server.rb
* create models that inherit from lib/model.rb
   * As in Rails' ActiveRecord, can perform basic SQL searches (e.g. `Cat.where('id = 1')` or `Cat.find(1)` ) as well as associations
   `has_many` and `belongs_to`
   * You'll need to require_relative models them on the controller
* create controllers that inherit from lib/controller_base.rb
  * write a method for each action you added to routes
  * can use `render`, `redirect_to`, and `render_content`
* create views in folders per controller
  * can use ERB to insert variables into HTML template.
