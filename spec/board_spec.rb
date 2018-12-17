require_relative '../models/board.rb'

RSpec.describe Board do
  let(:board) { Board.new columns: 7, rows: 6 }

  before do
    board.instance_variable_set :@cells, [
      %w(a b c d e 1),
      %w(f g h i j 2),
      %w(k l m n o 3),
      %w(p q r s t 4),
      %w(u v w x y 5),
      %w(a s d f g h),
      %w(6 7 8 9 0 f)
    ]
  end

  describe "#new" do
    it "creates board with empty cells" do
      expect(Board.new.to_a.flatten.uniq).to eq([nil])
    end
  end

  describe "#column" do
    it "provides column with the specified index" do
      expect(board.column(3)).to eq(%w(p q r s t 4))
    end
  end

  describe "#row" do
    it "provides row with the specified index" do
      expect(board.row(2)).to eq(%w(c h m r w d 8))
    end
  end

  describe "#diagonal_1" do
    context "given target on the main diagonal" do
      it "picks diagonal from top left to bottom right" do
        expect(board.diagonal_1(2, 2)).to eq( %w(a g m s y h) )
      end
    end

    context "given target off the main diagonal" do
      it "picks diagonal from top left to bottom right" do
        expect(board.diagonal_1(1, 4)).to eq( %w(d j 3) )
        expect(board.diagonal_1(3, 2)).to eq( %w(f l r x g) )
      end
    end

  end

  describe "#diagonal_2" do
    context "given target on the main diagonal" do
      it "picks diagonal from bottom left to top right" do
        expect(board.diagonal_2(2, 2)).to eq( %w(u q m i e) )
      end
    end

    context "given target off the main diagonal" do
      it "picks diagonal from bottom left to top right" do
        expect(board.diagonal_2(3, 4)).to eq( %w(7 d x t 3) )
        expect(board.diagonal_2(3, 2)).to eq( %w(a v r n j 1) )
      end
    end
  end

  describe "#full?" do
    let(:board) { Board.new columns: 7, rows: 7 }

    it "returns true when no free cells are left" do
      cells_data_full = %w(
        1 2 1 2 1 2 1
        1 2 1 2 1 2 1
        1 1 2 2 1 2 2
        2 2 1 1 2 1 1
        1 2 1 2 1 2 1
        1 1 2 2 1 2 2
        1 2 1 2 1 2 1
      )
      fill_board_cells board, cells_data_full
      expect(board.full?).to eq(true)
    end

    it "returns false when there is at least one free cell" do
      cells_data_with_free_cell = %w(
        1 2 1 2 1 2 1
        1 2 1 2 1 2 1
        1 1 2 2 1 2 nil
        2 2 1 1 2 1 1
        1 2 1 2 1 2 1
        1 1 2 2 1 2 2
        1 2 1 2 1 2 1
      )
      fill_board_cells board, cells_data_with_free_cell
      expect(board.full?).to eq(false)
    end
  end

  describe "#empty_cell_in_column_index" do
    let(:board) { Board.new columns: 3, rows: 3 }
    before do
      fill_board_cells board, %w(
          1 1 nil
          1 1 1
          1 1 1
      )
    end

    it "returns empty cell index if column has at least one empty cell" do
      expect(board.empty_cell_in_column_index(2)).to eq(0)
    end

    it "returns nil if column has no empty cells" do
      expect(board.empty_cell_in_column_index(1)).to eq(nil)
    end
  end

end
