require_relative 'piece'
require_relative 'tile'

class Board

  attr_accessor :board, :red_piece_count, :black_piece_count

  INITIALS = { red: [[0,1], [0,3], [0,5], [0,7],
                      [1,0], [1,2], [1,4], [1,6],
                      [2,1], [2,3], [2,5], [2,7]],

               black: [[5,0], [5,2], [5,4], [5,6],
                      [6,1], [6,3], [6,5], [6,7],
                      [7,0], [7,2], [7,4], [7,6]]

              }

  SYMBOLS = { [:red, :king] => "\u263a",
              [:red, :pawn] => "\u262e",
              [:black, :king] => "\u263b",
              [:black, :pawn] => "\u262f"
            }

  def initialize
    self.board = []
    8.times { board << Array.new(8) {Tile.new} }
    populate_board
  end

  def [](row, col)
    # take splat arguments and handle for different cases
    self.board[row][col]
  end

  def populate_board
    INITIALS.each_pair do |color, positions|
      case color
      when :red
        positions.each { |row, col| board[row][col].piece = Piece.new(:red, [row, col]) }
      when :black
        positions.each { |row, col| board[row][col].piece = Piece.new(:black, [row, col]) }
      end
    end
  end

  def display_board
    letters = ('A'..'H').to_a

    display = @board.map  { |row| letters.shift + '|' + row.map {|tile| !tile.no_piece? ? SYMBOLS[[tile.piece.color, tile.piece.type]] : '_' } .join('|') + '|' }

    display = ["  1 2 3 4 5 6 7 8"] + display + ["__________________"]
    puts display
  end

  def piece_counter
    self.black_piece_count = []
    self.red_piece_count = []
    @board.each do |row|
      row.each do |tile|
        if !tile.no_piece?
          tile.piece.color == "red" ? red_piece_count << tile.piece : black_piece_count << tile.piece
        end
      end
    end
    puts "Yin Yangs left: #{black_piece_count.length}"
    puts "Peaces left: #{red_piece_count.length}"
  end

end

# test = Board.new
# test.populate_board
# test.display_board
#
# p test