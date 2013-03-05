install:
	bash -c "bower install handlebars jquery lodash"

compile:
	bash -c "coffee -c app.coffee"
	bash -c "sass app.scss > app.css"