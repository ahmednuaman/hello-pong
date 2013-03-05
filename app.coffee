class Game

  constructor: (container) ->
    @addCanvas container

  addCanvas: (container) ->
    @canvas = document.createElement 'canvas'
    container = document.getElementById container

    @canvas.height = 300
    @canvas.width = 600

    container.appendChild @canvas

new Game 'container'