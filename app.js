//@ sourceMappingURL=app.map
// Generated by CoffeeScript 1.6.1
var Game;

Game = (function() {
  var ballRadius, ballStartDirectionX, ballStartDirectionY, ballStartX, ballStartY, courtLineWidth, padding, paddleHeight, paddleWidth;

  ballRadius = 20;

  ballStartX = 1;

  ballStartY = ballRadius;

  ballStartDirectionX = 7;

  ballStartDirectionY = 7;

  courtLineWidth = 3;

  paddleHeight = 60;

  paddleWidth = 10;

  padding = 20;

  function Game(container, interactive) {
    this.interactive = interactive != null ? interactive : false;
    this.scoreAI = 0;
    this.scorePlayer = 0;
    this.hasAI = false;
    this.ballDirectionX = ballStartDirectionX;
    this.ballDirectionY = ballStartDirectionY;
    this.addCanvas(container);
  }

  Game.prototype.addCanvas = function(container) {
    container = document.getElementById(container);
    this.canvas = document.createElement('canvas');
    this.canvas.height = 600;
    this.canvas.width = 900;
    this.paddingX = this.canvas.width - padding;
    this.paddingY = this.canvas.height - padding - paddleHeight;
    this.limitY = this.canvas.height - ballRadius;
    this.stage = new createjs.Stage(this.canvas);
    container.appendChild(this.canvas);
    if (!this.interactive) {
      return this.addBackground();
    }
  };

  Game.prototype.addBackground = function() {
    var background, backgroundGFX;
    background = new createjs.Shape();
    backgroundGFX = background.graphics;
    backgroundGFX.beginFill('#000000');
    backgroundGFX.drawRect(0, 0, this.canvas.width, this.canvas.height);
    backgroundGFX.endFill();
    this.stage.addChild(background);
    this.stage.update();
    if (!this.interactive) {
      this.addCourt();
    }
    return 'Added background';
  };

  Game.prototype.addCourt = function() {
    var courtGFX, x1, x2;
    this.canvasHalfWidth = this.canvas.width * .5;
    x1 = this.canvasHalfWidth - courtLineWidth;
    x2 = this.canvasHalfWidth + courtLineWidth;
    this.court = new createjs.Shape();
    courtGFX = this.court.graphics;
    courtGFX.setStrokeStyle(courtLineWidth);
    courtGFX.beginStroke('#999999');
    courtGFX.moveTo(x1, 0);
    courtGFX.lineTo(x1, this.canvas.height);
    courtGFX.moveTo(x2, this.canvas.height);
    courtGFX.lineTo(x2, 0);
    courtGFX.endStroke();
    this.stage.addChild(this.court);
    this.stage.update();
    if (!this.interactive) {
      this.addScores();
    }
    return 'Added court lines';
  };

  Game.prototype.addScores = function() {
    this.scorePlayerTxt = new createjs.Text;
    this.scorePlayerTxt.color = '#ffffff';
    this.scorePlayerTxt.font = '20px Quantico';
    this.scorePlayerTxt.text = 'Player: 0';
    this.scorePlayerTxt.textAlign = 'right';
    this.scorePlayerTxt.x = this.canvasHalfWidth - padding;
    this.scorePlayerTxt.y = padding;
    this.scoreAITxt = new createjs.Text;
    this.scoreAITxt.color = '#ffffff';
    this.scoreAITxt.font = '20px Quantico';
    this.scoreAITxt.text = 'Computer: 0';
    this.scoreAITxt.x = this.canvasHalfWidth + padding;
    this.scoreAITxt.y = padding;
    this.stage.addChild(this.scorePlayerTxt);
    this.stage.addChild(this.scoreAITxt);
    this.stage.update();
    if (!this.interactive) {
      this.addLeftPaddle();
    }
    return 'Added scores text';
  };

  Game.prototype.addLeftPaddle = function() {
    this.startY = (this.canvas.height - paddleHeight) * .5;
    this.leftPaddle = this.createPaddle();
    this.leftPaddle.x = padding;
    this.leftPaddle.y = this.startY;
    this.stage.addChild(this.leftPaddle);
    this.stage.update();
    if (!this.interactive) {
      this.addRightPaddle();
    }
    return 'Added left (player) paddle';
  };

  Game.prototype.addRightPaddle = function() {
    this.rightPaddle = this.createPaddle();
    this.rightPaddle.x = this.paddingX - paddleWidth;
    this.rightPaddle.y = this.startY;
    this.stage.addChild(this.rightPaddle);
    this.stage.update();
    if (!this.interactive) {
      this.enableControls();
    }
    return 'Added right (AI/computer) paddle';
  };

  Game.prototype.createPaddle = function() {
    var paddle, paddleGFX;
    paddle = new createjs.Shape();
    paddleGFX = paddle.graphics;
    paddleGFX.beginFill('#ffffff');
    paddleGFX.moveTo(0, 0);
    paddleGFX.lineTo(paddleWidth, 0);
    paddleGFX.lineTo(paddleWidth, paddleHeight);
    paddleGFX.lineTo(0, paddleHeight);
    paddleGFX.endFill();
    return paddle;
  };

  Game.prototype.enableControls = function() {
    var that;
    that = this;
    document.onkeydown = function(event) {
      return that.handleOnKeyDown.apply(that, arguments);
    };
    if (!this.interactive) {
      this.addBall();
    }
    return 'Enabled player controls';
  };

  Game.prototype.handleOnKeyDown = function(event) {
    switch (event.keyCode) {
      case 38:
        return this.moveLeftPaddleBy(ballStartDirectionY * -1);
      case 40:
        return this.moveLeftPaddleBy(ballStartDirectionY);
    }
  };

  Game.prototype.moveLeftPaddleBy = function(y) {
    return this.movePaddleTo(this.leftPaddle, this.leftPaddle.y + y);
  };

  Game.prototype.movePaddleTo = function(paddle, y) {
    if (y >= padding && y <= this.paddingY) {
      paddle.y = y;
      return this.stage.update();
    }
  };

  Game.prototype.addBall = function() {
    var ballGFX;
    this.ball = new createjs.Shape();
    this.ball.x = ballStartX;
    this.ball.y = ballStartY;
    ballGFX = this.ball.graphics;
    ballGFX.beginFill('#ff0000');
    ballGFX.drawCircle(0, 0, ballRadius);
    ballGFX.endFill();
    this.ballLastY = 0;
    this.stage.addChildAt(this.ball, (this.stage.getChildIndex(this.court)) + 1);
    this.stage.update();
    if (!this.interactive) {
      this.startBallMovement();
    }
    return 'Added ball';
  };

  Game.prototype.startBallMovement = function() {
    var that;
    that = this;
    createjs.Ticker.addEventListener('tick', function(event) {
      return that.handleTickerTick.apply(that, arguments);
    });
    if (!this.interactive) {
      this.addAI();
    }
    return 'Started ball movement';
  };

  Game.prototype.addAI = function() {
    this.hasAI = true;
    return 'Added AI to computer opponent';
  };

  Game.prototype.handleTickerTick = function(event) {
    this.ball.x = this.ball.x + this.ballDirectionX;
    this.ball.y = this.ball.y + this.ballDirectionY;
    if (this.ball.y < ballRadius || this.ball.y > this.limitY) {
      this.ballDirectionY = this.ballDirectionY * -1;
    }
    if (this.ball.x < 0) {
      this.scoreAI++;
      this.scoreAITxt.text = 'Computer: ' + this.scoreAI;
    }
    if (this.ball.x > this.canvas.width) {
      this.scorePlayer++;
      this.scorePlayerTxt.text = 'Player: ' + this.scorePlayer;
    }
    if (this.ball.x < 0 || this.ball.x > this.canvas.width) {
      this.ballDirectionX = ballStartDirectionX;
      this.ballDirectionY = ballStartDirectionY;
      this.ball.x = ballStartX;
      this.ball.y = ballStartY;
    }
    this.rightPaddlePts = this.ball.globalToLocal(this.rightPaddle.x, this.rightPaddle.y);
    if (this.ball.hitTest(this.rightPaddlePts.x, this.rightPaddlePts.y) || this.ball.hitTest(this.rightPaddlePts.x, this.rightPaddlePts.y + paddleHeight) || this.ball.hitTest(this.rightPaddlePts.x, this.rightPaddlePts.y + paddleHeight * .5)) {
      this.ballDirectionX = this.ballDirectionX * -1;
    }
    this.leftPaddlePts = this.ball.globalToLocal(this.leftPaddle.x + paddleWidth, this.leftPaddle.y);
    if (this.ball.hitTest(this.leftPaddlePts.x, this.leftPaddlePts.y) || this.ball.hitTest(this.leftPaddlePts.x, this.leftPaddlePts.y + paddleHeight) || this.ball.hitTest(this.leftPaddlePts.x, this.leftPaddlePts.y + paddleHeight * .5)) {
      this.ballDirectionX = this.ballDirectionX * -1;
    }
    if (this.hasAI) {
      this.movePaddleTo(this.rightPaddle, this.ballLastY);
    }
    this.ballLastY = this.ball.y;
    return this.stage.update();
  };

  return Game;

})();