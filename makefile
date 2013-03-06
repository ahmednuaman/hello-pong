install:
	bash -c "bower install EaselJS TweenJS"

compile:
	bash -c "coffee -c -m -b app.coffee"
	bash -c "sass app.scss > app.css"