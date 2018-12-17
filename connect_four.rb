require './models/game.rb'
require './models/board.rb'
require './game_controller.rb'

board = Board.new columns: 7, rows: 6
game  = Game.new board: board

GameController.new(game).play
