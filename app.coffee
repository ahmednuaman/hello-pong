class Game
  constructor: (container) ->
    @addCanvas container

  addCanvas: (container) ->
    container = document.getElementById container
    @canvas = document.createElement 'canvas'
    @canvas.height = 600
    @canvas.width = 900
    @stage = new createjs.Stage @canvas

    container.appendChild @canvas

    @addBackground()

  addBackground: () ->
    @background = new createjs.Shape()
    @backgroundGFX = @background.graphics
    @backgroundGFX.beginFill '#000000'
    @backgroundGFX.drawRect 0, 0, @canvas.width, @canvas.height

    @stage.addChild @background
    @stage.update()

    @addCourt()

  addCourt: () ->
    half = @canvas.width * .5
    width = 3
    x1 = half - width
    x2 = half + width
    console.log x1, x2
    @court = new createjs.Shape()
    @courtGFX = @court.graphics
    @courtGFX.setStrokeStyle width
    @courtGFX.beginStroke '#999999'
    @courtGFX.moveTo x1, 0
    @courtGFX.lineTo x1, @canvas.height
    @courtGFX.moveTo x2, @canvas.height
    @courtGFX.lineTo x2, 0

    @stage.addChild @court
    @stage.update()

game = new Game 'container'