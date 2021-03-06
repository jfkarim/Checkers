require 'debugger'
require_relative 'board'
require_relative 'piece'
require_relative 'tile'
require_relative 'player'
require_relative 'king'

class Checkers

  attr_accessor :game_board, :player1, :player2, :game_board

  def initialize
    self.game_board = Board.new
    self.player1 = nil
    self.player2 = nil
    @current_player = nil
    set_players
  end

  #SETTING PLAYER METHODS

  def set_players
    self.player1 = Player.new(:black)
    self.player2 = Player.new(:red)
    @current_player = player1
  end

  def change_players
    @current_player == player1 ? @current_player = player2 : @current_player = player1
  end

  #GAME FLOW METHODS (PLAY, TURN, WIN, INPUT ERRORS...)

  def turn
    move_input = @current_player.get_inputs
    if !valid_piece?(@current_player.color, game_board[move_input[0][0], move_input[0][1]].piece)
      puts "\u26d4 \n Wrong pieces IDIOT!! kidding, you're not an idiot...\n at least not a big one\n \u26d4"
      turn
    end
    kind_of_move(move_input)
    game_board.display_board
    game_board.piece_counter
    win
    change_players
  end

  def play
    game_board.display_board

    until win
      turn
    end

    play_again?
  end

  def play_again?
    puts "Play again? (y/n)"
    ans = gets.chomp.downcase[0]
    if ans == 'y'
      self.game_board = Board.new
      play
    end
  end

  def win
    false
    if game_board.black_piece_count == 0
      puts "\u262e Peaces WIN!! \u262e"
      return true
    elsif game_board.red_piece_count == 0
      puts "\u262f YinYangs WIN!! \u262f"
      return true
    end
  end

  def origin_empty?(origin)
    game_board[origin[0], origin[1]].no_piece?
  end

  def valid_piece?(current_player_color, selected_piece)
    selected_piece && (selected_piece.color == current_player_color)
  end

  #PIECE MOVEMENT METHODS (WILL MOVE MOST TO PIECE CLASS)

  def kind_of_move(inputs)
    move(inputs) if inputs.length == 2
    move_sequence(inputs) if inputs.length > 2
  end

  def move_sequence(inputs)
    move_count = inputs.length
    i = 0
    while i < move_count - 1
      move([inputs[i], inputs[i+1]])
      i += 1
    end
  end

  def move(inputs)
    origin, destination = inputs[0], inputs[1]

    if origin_empty?(origin)
      puts "You selected an invalid square to move from"
    end

    difference = [destination[0] - origin[0], destination[1] - origin[1]]

    if difference[0].to_f.abs == 2 && difference[1].to_f.abs == 2
      perform_jump(origin, destination)
    elsif difference[0].to_f.abs == 1 && difference[1].to_f.abs == 1
      perform_slide(origin, destination)
    else
      puts "Invalid move"
    end
  end

  def perform_slide(origin, destination)
    current_piece = game_board[origin[0], origin[1]].piece.dup

    if valid_moves(current_piece).include?(destination)
      perform_move(origin, destination)
    end
  end

  def perform_jump(origin, destination)
    current_piece = game_board[origin[0], origin[1]].piece.dup
    surroundings = surroundings(current_piece.position)
    jump_array = jumps_possible(surroundings, current_piece.position)

    if valid_moves(current_piece).include?(destination)
      perform_move(origin, destination)
      remove_jumped(origin, destination)
    end
  end

  def remove_jumped(origin, destination)
    difference = [destination[0] - origin[0], destination[1] - origin[1]]
    jumped = [origin[0] + (difference[0] / 2), origin[1] + (difference[1] / 2)]
    game_board[jumped[0], jumped[1]].piece = nil
    # just delete from an array that contains all players pieces
  end

  def perform_move(origin, destination)
    game_board[destination[0], destination[1]].piece = game_board[origin[0], origin[1]].piece
    game_board[origin[0], origin[1]].piece = nil
    game_board[destination[0], destination[1]].piece.set_new_pos(destination)
    king_me(game_board[destination[0], destination[1]].piece)
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

    valid_moves
  end

  def jumps_possible(surroundings, current_position)
    jump_array = []

    surroundings.each do |neighbor|
      difference = [neighbor[0] - current_position[0], neighbor[1] - current_position[1]]
      jump_pos = [neighbor[0] + difference[0], neighbor[1] + difference[1]]
      next if !within_board?(jump_pos)
      jump_tile = game_board[jump_pos[0], jump_pos[1]]
      if game_board[jump_pos[0], jump_pos[1]] && game_board[jump_pos[0], jump_pos[1]].no_piece?
        if game_board[neighbor[0], neighbor[1]].piece.color != game_board[current_position[0], current_position[1]].piece.color
          if !game_board[neighbor[0], neighbor[1]].no_piece?
            jump_array << jump_pos if jump_tile.no_piece?
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
      next if !within_board?(neighbor)
      tile = game_board[neighbor[0], neighbor[1]]
      surroundings << tile.piece.position if !tile.no_piece?
    end

    surroundings
  end

  def king_me(piece)
    current_position = piece.position
    color = piece.color
    red_line, black_line = back_line(0), back_line(7)
    if color == :black
      if red_line.include?(current_position)
        game_board[current_position[0], current_position[1]].piece = King.new(color, current_position)
      end
    else
      if black_line.include?(current_position)
        game_board[current_position[0], current_position[1]].piece = King.new(color, current_position)
      end
    end
  end

  def back_line(desired)
    line = []
    game_board.board.each_with_index do |row, i1|
      row.each_with_index { |tile, i2| line << [i1,i2] if tile && i1 == desired }
    end
    line
  end

  def within_board?(pos)
    (0...8).to_a.include?(pos[0]) && (0...8).to_a.include?(pos[1])
  end

end

test = Checkers.new
test.play
