require_relative '../models/game.rb'
require_relative '../models/board.rb'

RSpec.describe Game do
  let(:game) { Game.new board: Board.new(columns: 7, rows: 6) }

  describe "#new" do
    it "creates game where RED moves first" do
      expect(game.whose_move).to eq(Game::RED)
    end
  end

  describe "#move" do

    context "given column without available cells" do
      it "raises exception" do
        game.board_size_rows.times { game.move(1) } 
        expect{ game.move(1) }.to raise_error Game::ColumnFullError
      end
    end

    context "given column with available cells" do
      it "fills a cell in given column" do
        game.move(2)
        column_2 = game.board.map{|row| row[2]}
        expect(column_2.reject {|i| i == nil }.count).to eq(1)
      end

      context "one player completes four" do
        it "indicates winner" do
          (Game::GOAL-1).times do
            game.move 1 # RED move
            game.move 2 # YELLOW move
          end
          game.move 1 # RED move
          expect(game.winner).to eq(Game::RED)
        end
      end

      context "when board is complete without a completed four" do
        it "indicates draw" do
          cells_data = %w(
            1 2 1 2 1 2 nil
            1 2 1 2 1 2 1
            1 1 2 2 1 2 2
            2 2 1 1 2 1 1
            1 2 2 1 1 2 1
            1 1 2 2 1 2 2
            1 2 1 2 1 2 1
          )
          board = game.instance_variable_get :@board
          fill_board_cells board, cells_data
          game.move(6)

          expect(game.draw?).to eq(true)
        end
      end

      context "when four is not yet complete, neither is not complete board" do
        it "passes move to the next player" do
          expect(game.whose_move).to eq(Game::RED)
          game.move(2)
          expect(game.whose_move).to eq(Game::YELLOW)
          game.move(2)
          expect(game.whose_move).to eq(Game::RED)
        end
      end
    end

  end

  describe "#finished?" do
    it "responds true if game is draw" do
      expect(game).to receive(:draw?).and_return(true)
      expect(game.finished?).to eq(true)
    end
    it "responds true if there is a winner" do
      expect(game).to receive(:draw?).and_return(false)
      expect(game).to receive(:winner).and_return(Game::RED)
      expect(game.finished?).to eq(true)
    end
    it "responds false if not draw and no winner" do
      expect(game).to receive(:draw?).and_return(false)
      expect(game).to receive(:winner).and_return(nil)
      expect(game.finished?).to eq(false)
    end
  end

  describe "#player_name" do
    it "returns a string with player name (color) corresponding to player's value on board" do
      expect(game.player_name(Game::RED)).to eq("red")
      expect(game.player_name(Game::YELLOW)).to eq("yellow")
    end
  end

end
