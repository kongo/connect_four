require 'tty-prompt'
require 'tty-table'
require 'tty-cursor'
require 'colorize'

class GameController

  def initialize(game)
    @game         = game
    @column_range = "1-#{game.board_size}"
    @prompt       = TTY::Prompt.new
    @cursor       = TTY::Cursor
  end

  def play
    clear_screen
    print_board
    make_move until @game.finished?
    print_result
  end

  private

  def make_move
    choice = prompt_ask
    @game.move choice.to_i - 1
    clear_screen
    print_board
  rescue @game.class::ColumnFullError
    @prompt.error "Column full"
  end

  def clear_screen
    print @cursor.clear_lines 1000, :up
  end

  def print_board
    table = TTY::Table.new (1..@game.board_size).to_a, board_to_string(@game.board)
    puts table.render(:unicode)
  end

  def print_result
    message = if @game.draw?
                "Draw game!".colorize(mode: :bold)
              else
                winner_name = @game.player_name(@game.winner)
                player_name_formatted(winner_name) + " win!"
              end
    @prompt.ok message
  end

  def board_to_string(board)
    board.map { |line| line.map { |item| player_value_display item } }
  end

  def player_value_display(item)
    return ' ' if item.nil?
    "\u25A0".colorize @game.player_name(item).to_sym
  end

  def prompt_ask
    player_name = player_name_formatted @game.player_name(@game.whose_move)
    @prompt.ask("#{player_name} move [#{@column_range}]:") do |q|
      q.in @column_range
      q.messages[:range?] = '%{value} out of expected range #{in}'
    end
  end

  def player_name_formatted(player_name)
    player_name.upcase.colorize(player_name.to_sym).colorize(mode: :bold)
  end

end

