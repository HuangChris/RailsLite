#Rails Lite

##Steps to run a basic webapp:

* Make your database (cats.db and cats.sql)
  * You can rename them if you like, but change the names in db_connection.rb
* write routes in app/routes.rb
  * for now, they have to be written directly on the server.rb
* create models that inherit from lib/model.rb
   * I don't remember what you can do on your models besides association and searches by SQL string (e.g. Cat.where('id = 1')) or id (Cat.find(1))
   * You'll need to require_relative them on the controller
* create controllers that inherit from lib/controller_base.rb
  * write a method for each action you added to routes
  * can use render, redirct_to, and render_content
* create views in folders per controller
  * can use ERB
