
require_relative 'board'
require_relative 'piece'
require_relative 'tile'

class Checkers

  attr_accessor :game_board, :player1, :player2, :game_board

  def initialize
    self.game_board = Board.new
    # self.player1 = nil
    # self.player2 = nil
    # set_players
    # @current_player = nil
  end

  def board_dup
    serialized_board = Marshal::dump(game_board)
    Marshal::load(serialized_board)
  end

  def perform_slide(origin, destination)
    current_piece = game_board[origin[0], origin[1]].piece.dup

    if valid_moves(current_piece).include?(destination)
      perform_move(origin, destination)
    end
  end

  def move(inputs)
    origin, destination = inputs[0], inputs[1]

    difference = [destination[0] - origin[0], destination[1] - origin[1]]

    if difference[0].to_f.abs == 2 && difference[1].to_f.abs == 2
      perform_jump(origin, destination)
    elsif difference[0].to_f.abs == 1 && difference[1].to_f.abs == 1
      perform_slide(origin, destination)
    else
      puts "Invalid move"
    end
  end

  def perform_jump(origin, destination)
    current_piece = game_board[origin[0], origin[1]].piece.dup

    if valid_moves(current_piece).include?(destination)
      perform_move(origin, destination)
    end
  end

  def perform_move(origin, destination)
    temp = game_board[origin[0], origin[1]].piece.dup
    game_board[destination[0], destination[1]].piece = temp
    game_board[origin[0], origin[1]].piece = nil
  end

  def valid_moves(piece)
    current_position = piece.position
    valid_moves = []
    surroundings = surroundings(current_position)

    if jumps_possible(surroundings, current_position)
       possible_jumps = jumps_possible(surroundings, current_position)
    else
       possible_jumps = []
    end

    slide_moves = piece.slide_moves
    valid_moves += (slide_moves - surroundings) + (piece.jump_moves & possible_jumps)

    puts "Current position is"
    p current_position

    puts "surroundings are:"
    p surroundings

    puts "jumps possible are"
    p possible_jumps

    puts "slide moves possible are"
    p slide_moves

    puts "valid_moves are"
    p valid_moves

    valid_moves
  end

  def jumps_possible(surroundings, current_position)
    jump_array = []

    surroundings.each do |neighbor|
      difference = [neighbor[0] - current_position[0], neighbor[1] - current_position[1]]
      jump_tile = [neighbor[0] + difference[0], neighbor[0] + difference[0]]
      if game_board[jump_tile[0], jump_tile[1]].no_piece?
        if game_board[neighbor[0], neighbor[1]].piece.color != game_board[current_position[0], current_position[1]].piece.color
          if !game_board[neighbor[0], neighbor[1]].no_piece?
            jump_array << jump_tile
          end
        end
      end
    end

    jump_array
  end

  def surroundings(current_position)
    surroundings = []
    around = [[-1,-1], [-1,1], [1,-1], [1,1]]

    around.each do |new_pos|
      neighbor = [current_position[0] + new_pos[0], current_position[1] + new_pos[1]]
      tile = game_board[neighbor[0], neighbor[1]]
      surroundings << tile.piece.position if !tile.no_piece?
    end

    surroundings
  end

  def set_players
    self.player1 = Player.new('red')
    self.player2 = Player.new('black')
  end

  def change_players
    @current_player == player1 ? @current_player = player2 : @current_player = player1
  end

end

test = Checkers.new
test.game_board.display_board
puts "After move made"
test.move([[2,1], [3,2]])
test.game_board.display_board

# temp_board = board_dup
# temp = temp_board[origin[0], origin[1]].piece.dup
# temp_board[destination[0], destination[1]].piece = temp
# temp_board[origin[0], origin[1]].piece = nil
