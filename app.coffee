class Game
  courtLineWidth = 3
  paddleHeight = 60
  paddleWidth = 10
  padding = 20

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
    x1 = half - courtLineWidth
    x2 = half + courtLineWidth
    @court = new createjs.Shape()
    @courtGFX = @court.graphics
    @courtGFX.setStrokeStyle courtLineWidth
    @courtGFX.beginStroke '#999999'
    @courtGFX.moveTo x1, 0
    @courtGFX.lineTo x1, @canvas.height
    @courtGFX.moveTo x2, @canvas.height
    @courtGFX.lineTo x2, 0
    @courtGFX.endStroke()

    @stage.addChild @court
    @stage.update()

    @addLeftPaddle()

  addLeftPaddle: () ->
    @leftPaddle = @createPaddle()
    @leftPaddle.x = padding
    @leftPaddle.y = padding

    @stage.addChild @leftPaddle
    @stage.update()

    @addRightPaddle()

  addRightPaddle: () ->
    @rightPaddle = @createPaddle()
    @rightPaddle.x = @canvas.width - paddleWidth - padding
    @rightPaddle.y = padding

    @stage.addChild @rightPaddle
    @stage.update()

  createPaddle: () ->
    paddle = new createjs.Shape()
    paddleGFX = paddle.graphics
    paddleGFX.beginFill '#ffffff'
    paddleGFX.moveTo 0, 0
    paddleGFX.lineTo paddleWidth, 0
    paddleGFX.lineTo paddleWidth, paddleHeight
    paddleGFX.lineTo 0, paddleHeight
    paddleGFX.endFill()

    paddle

game = new Game 'container'