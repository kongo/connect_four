class Board

  attr_reader :board_size_columns, :board_size_rows

  def initialize(columns: 7, rows: 6)
    @board_size_columns = columns
    @board_size_rows    = rows
    init_cells
  end

  def to_a
    @cells.dup
  end

  def set_cell_value(column, row, val)
    @cells[column][row] = val
  end

  def column(column_number)
    @cells[column_number]
  end

  def row(row_number)
    @cells.map { |col| col[row_number] }
  end

  def diagonal_1(column_number, row_number)
    subtract    = [column_number, row_number].min
    source_cell = [column_number - subtract, row_number - subtract]
    steps       = [
      @board_size_columns - source_cell[0] - 1,
      @board_size_rows    - source_cell[1]
    ].min

    (0..steps-1).reduce([]) { |a, i|
      a << @cells[source_cell[0] + i][source_cell[1] + i]
      a
    }
  end

  def diagonal_2(column_number, row_number)
    subtract    = [board_size_columns - 1 - column_number, row_number].min
    source_cell = [column_number + subtract, row_number - subtract]
    steps       = [
      source_cell[0] + 1,
      @board_size_rows - source_cell[1]
    ].min

    (0..steps-1).reduce([]) { |a, i|
      a << @cells[source_cell[0] - i][source_cell[1] + i]
      a
    }
  end

  def full?
    @cells.flatten.none? {|c| c.nil? }
  end

  def empty_cell_in_column_index(column_number)
    @cells[column_number].find_index(nil)
  end

  private

  def init_cells
    @cells = (1..@board_size_columns).map {
      (1..@board_size_rows).map { nil }
    } 
  end

end
