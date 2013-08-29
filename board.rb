class Board

  attr_accessor :board, :red_piece_count, :black_piece_count

  INITIALS = { 'r' => [[0,1], [0,3], [0,5], [0,7],
                      [1,0], [1,2], [1,4], [1,6],
                      [2,1], [2,3], [2,5], [2,7]]

               'b' => [[5,0], [5,2], [5,4], [5,6],
                      [6,1], [6,3], [6,5], [6,7],
                      [7,0], [7,2], [7,4], [7,6]]

              }

  def initialize
    self.board = []
    8.times { board << Array.new(8) {Tile.new} }
    self.red_piece_count = []
    self.black_piece_count = []
  end

  def [](row, col)
    board[row][col]
  end




end