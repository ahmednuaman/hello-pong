class Game
  ballRadius = 20
  ballStartX = 1
  ballStartY = ballRadius
  ballStartDirectionX = 7
  ballStartDirectionY = 7
  courtLineWidth = 3
  paddleHeight = 60
  paddleWidth = 10
  padding = 20

  constructor: (container, @interactive=false) ->
    @scoreAI = 0
    @scorePlayer = 0
    @hasAI = false
    @ballDirectionX = ballStartDirectionX
    @ballDirectionY = ballStartDirectionY
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

    if !@interactive
      @addBackground()

  addBackground: () ->
    background = new createjs.Shape()
    backgroundGFX = background.graphics
    backgroundGFX.beginFill '#000000'
    backgroundGFX.drawRect 0, 0, @canvas.width, @canvas.height
    backgroundGFX.endFill()

    @stage.addChild background
    @stage.update()

    if !@interactive
      @addCourt()

  addCourt: () ->
    @canvasHalfWidth = @canvas.width * .5
    x1 = @canvasHalfWidth - courtLineWidth
    x2 = @canvasHalfWidth + courtLineWidth
    @court = new createjs.Shape()
    courtGFX = @court.graphics
    courtGFX.setStrokeStyle courtLineWidth
    courtGFX.beginStroke '#999999'
    courtGFX.moveTo x1, 0
    courtGFX.lineTo x1, @canvas.height
    courtGFX.moveTo x2, @canvas.height
    courtGFX.lineTo x2, 0
    courtGFX.endStroke()

    @stage.addChild @court
    @stage.update()

    if !@interactive
      @addScores()

  addScores: () ->
    @scorePlayerTxt = new createjs.Text
    @scorePlayerTxt.color = '#ffffff'
    @scorePlayerTxt.font = '20px Quantico'
    @scorePlayerTxt.text = 'Player: 0'
    @scorePlayerTxt.textAlign = 'right'
    @scorePlayerTxt.x = @canvasHalfWidth - padding
    @scorePlayerTxt.y = padding
    @scoreAITxt = new createjs.Text
    @scoreAITxt.color = '#ffffff'
    @scoreAITxt.font = '20px Quantico'
    @scoreAITxt.text = 'Computer: 0'
    @scoreAITxt.x = @canvasHalfWidth + padding
    @scoreAITxt.y = padding

    @stage.addChild @scorePlayerTxt
    @stage.addChild @scoreAITxt
    @stage.update()

    if !@interactive
      @addLeftPaddle()

  addLeftPaddle: () ->
    @startY = (@canvas.height - paddleHeight) * .5
    @leftPaddle = @createPaddle()
    @leftPaddle.x = padding
    @leftPaddle.y = @startY

    @stage.addChild @leftPaddle
    @stage.update()

    if !@interactive
      @addRightPaddle()

  addRightPaddle: () ->
    @rightPaddle = @createPaddle()
    @rightPaddle.x = @paddingX - paddleWidth
    @rightPaddle.y = @startY

    @stage.addChild @rightPaddle
    @stage.update()

    if !@interactive
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

    if !@interactive
      @addBall()

  handleOnKeyDown: (event) ->
    switch event.keyCode
      when 38 then @moveLeftPaddleBy ballStartDirectionY * -1
      when 40 then @moveLeftPaddleBy ballStartDirectionY

  moveLeftPaddleBy: (y) ->
    @movePaddleTo @leftPaddle, @leftPaddle.y + y

  movePaddleTo: (paddle, y) ->
    if y >= padding and y <= @paddingY
      paddle.y = y

      @stage.update()

  addBall: () ->
    @ball = new createjs.Shape()
    @ball.x = ballStartX
    @ball.y = ballStartY
    ballGFX = @ball.graphics
    ballGFX.beginFill '#ff0000'
    ballGFX.drawCircle 0, 0, ballRadius
    ballGFX.endFill()

    @ballLastY = 0

    @stage.addChildAt @ball, (@stage.getChildIndex @court) + 1
    @stage.update()

    if !@interactive
      @startBallMovement()

  startBallMovement: () ->
    that = @

    createjs.Ticker.addEventListener 'tick', (event) ->
      that.handleTickerTick.apply that, arguments

    if !@interactive
      @addAI()

  addAI: () ->
    @hasAI = true

  handleTickerTick: (event) ->
    @ball.x = @ball.x + @ballDirectionX
    @ball.y = @ball.y + @ballDirectionY

    if @ball.y < ballRadius or @ball.y > @limitY
      @ballDirectionY = @ballDirectionY * -1

    if @ball.x < 0
      @scoreAI++
      @scoreAITxt.text = 'Computer: ' + @scoreAI

    if @ball.x > @canvas.width
      @scorePlayer++
      @scorePlayerTxt.text = 'Player: ' + @scorePlayer

    if @ball.x < 0 or @ball.x > @canvas.width
      @ballDirectionX = ballStartDirectionX
      @ballDirectionY = ballStartDirectionY
      @ball.x = ballStartX
      @ball.y = ballStartY

    @rightPaddlePts = @ball.globalToLocal @rightPaddle.x, @rightPaddle.y

    if @ball.hitTest(@rightPaddlePts.x, @rightPaddlePts.y) or
    @ball.hitTest(@rightPaddlePts.x, @rightPaddlePts.y + paddleHeight) or
    @ball.hitTest(@rightPaddlePts.x, @rightPaddlePts.y + paddleHeight * .5)
      @ballDirectionX = @ballDirectionX * -1

    @leftPaddlePts = @ball.globalToLocal @leftPaddle.x + paddleWidth, @leftPaddle.y

    if @ball.hitTest(@leftPaddlePts.x, @leftPaddlePts.y) or
    @ball.hitTest(@leftPaddlePts.x, @leftPaddlePts.y + paddleHeight) or
    @ball.hitTest(@leftPaddlePts.x, @leftPaddlePts.y + paddleHeight * .5)
      @ballDirectionX = @ballDirectionX * -1

    if @hasAI
      @movePaddleTo @rightPaddle, @ballLastY

    @ballLastY = @ball.y

    @stage.update()