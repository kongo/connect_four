require './models/game.rb'
require './models/board.rb'
require './game_controller.rb'

board = Board.new size: 7
game  = Game.new board: board

GameController.new(game).play
