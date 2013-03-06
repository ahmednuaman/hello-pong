install:
	bash -c "bower install handlebars jquery lodash"

compile:
	bash -c "coffee -c -m -b app.coffee"
	bash -c "sass app.scss > app.css"