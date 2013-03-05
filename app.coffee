class Game

  constructor: (container) ->
    @addCanvas container
    @addBackground()

  addCanvas: (container) ->
    container = document.getElementById container
    @canvas = document.createElement 'canvas'
    @canvas.height = 400
    @canvas.width = 800
    @stage = new createjs.Stage @canvas

    container.appendChild @canvas

  addBackground: () ->
    @background = new createjs.Shape()
    @backgroundGFX = @background.graphics
    @backgroundGFX.beginFill '#000000'
    @backgroundGFX.drawRect 0, 0, @canvas.width, @canvas.height

    @stage.addChild @background
    @stage.update()


game = new Game 'container'