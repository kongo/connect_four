require 'forwardable'

class Game

  class ColumnFullError < StandardError; end

  RED        = 1
  YELLOW     = 2
  GOAL       = 4

  PLAYER_NAMES = { RED => 'red', YELLOW => 'yellow' }

  attr_reader :whose_move
  attr_reader :winner
  
  def initialize(board:)
    @whose_move = RED
    @winner     = nil
    @draw       = false
    @board      = board
  end

  extend Forwardable
  delegate board_size: :@board

  def board
    max_index = @board.board_size - 1
    data = (0..max_index).map { |i|
      (0..max_index).map { |j| @board.to_a[j][max_index-i] }
    }
  end

  def draw?
    @draw
  end

  def finished?
    !!(draw? || winner)
  end

  def move(column)
    row = @board.empty_cell_in_column_index(column)

    if row
      @board.set_cell_value(column, row, @whose_move)
    else
      raise ColumnFullError
    end

    check_winner(column, row, @whose_move) ||
      check_draw ||
      switch_whose_move
  end

  def player_name(player_value)
    PLAYER_NAMES[player_value]
  end

  private

  def max_index
    board_size - 1
  end

  def check_winner col, row, player
    lines = [
      @board.column(col),
      @board.row(row),
      @board.diagonal_1(col, row),
      @board.diagonal_2(col, row)
    ]
    if lines.any? { |line| line_contains_goal?(line, player) }
      @winner = player
    end
  end

  def check_draw
    @draw = @board.full? && @winner.nil?
  end

  def line_contains_goal?(line, value)
    return false if line.length < GOAL
    targets = (0..(max_index - GOAL )).map { |i| line[i, GOAL] }
    targets.any? { |target| target.length == GOAL && target.uniq == [value] }
  end

  def switch_whose_move
    @whose_move = (@whose_move == RED) ? YELLOW : RED
  end

end
