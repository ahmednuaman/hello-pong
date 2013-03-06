install:
	bash -c "bower install EaselJS"
	bash -c "bower install git@github.com:ahmednuaman/consolejs.git"

compile:
	bash -c "coffee -c -m -b app.coffee"
	bash -c "sass app.scss > app.css"