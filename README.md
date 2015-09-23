* Rails Lite

Steps to run a basic webapp:

write routes in app/routes.rb
create app/models that inherit from lib/model.rb
  I don't remember what you can do on your models besides associations
    and searches by SQL string (e.g. Cat.where('id = 1')) or id (Cat.find(1))
create app/controllers that inherit from lib/controller_base.rb
  write a method for each action you added to routes
  can use render, redirct_to, and render_content
create views in folders per controller
  can use ERB
