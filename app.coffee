class Game
  ballRadius = 20
  courtLineWidth = 3
  paddleHeight = 60
  paddleWidth = 10
  padding = 20

  constructor: (container) ->
    @ballDirectionX = 5
    @ballDirectionY = 5
    @addCanvas container

  addCanvas: (container) ->
    container = document.getElementById container
    @canvas = document.createElement 'canvas'
    @canvas.height = 600
    @canvas.width = 900
    @paddingX = @canvas.width - padding
    @paddingY = @canvas.height - padding - paddleHeight
    @limitY = @canvas.height - ballRadius
    @stage = new createjs.Stage @canvas

    container.appendChild @canvas

    @addBackground()

  addBackground: () ->
    background = new createjs.Shape()
    backgroundGFX = background.graphics
    backgroundGFX.beginFill '#000000'
    backgroundGFX.drawRect 0, 0, @canvas.width, @canvas.height
    backgroundGFX.endFill()

    @stage.addChild background
    @stage.update()

    @addCourt()

  addCourt: () ->
    half = @canvas.width * .5
    x1 = half - courtLineWidth
    x2 = half + courtLineWidth
    court = new createjs.Shape()
    courtGFX = court.graphics
    courtGFX.setStrokeStyle courtLineWidth
    courtGFX.beginStroke '#999999'
    courtGFX.moveTo x1, 0
    courtGFX.lineTo x1, @canvas.height
    courtGFX.moveTo x2, @canvas.height
    courtGFX.lineTo x2, 0
    courtGFX.endStroke()

    @stage.addChild court
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
    @rightPaddle.x = @paddingX - paddleWidth
    @rightPaddle.y = padding

    @stage.addChild @rightPaddle
    @stage.update()

    @enableControls()

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

  enableControls: () ->
    that = @

    document.onkeydown = (event) ->
      that.handleOnKeyDown.apply that, arguments

    @addBall()

  handleOnKeyDown: (event) ->
    switch event.keyCode
      when 38 then @moveLeftPaddleBy -5
      when 40 then @moveLeftPaddleBy 5

  moveLeftPaddleBy: (y) ->
    target = @leftPaddle.y + y

    if target >= padding and target <= @paddingY
      @leftPaddle.y = target

      @stage.update()

  addBall: () ->
    @ball = new createjs.Shape()
    ballGFX = @ball.graphics
    ballGFX.beginFill '#ff0000'
    ballGFX.drawCircle 0, 0, ballRadius
    ballGFX.endFill()

    @stage.addChild @ball
    @stage.update()

    @startBallMovement()

  startBallMovement: () ->
    that = @

    createjs.Ticker.addEventListener 'tick', (event) ->
      that.handleTickerTick.apply that, arguments

  handleTickerTick: (event) ->
    @ball.x = @ball.x + @ballDirectionX
    @ball.y = @ball.y + @ballDirectionY

    if @ball.y <= 0 or @ball.y >= @limitY
      @ballDirectionY = @ballDirectionY * -1


    @stage.update()

game = new Game 'container'