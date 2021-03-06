class Piece
  attr_accessor :color, :position, :slide_increments, :jump_increments, :type


  def initialize(color, position, type = :pawn)
    self.color = color
    self.position = position
    self.type = type
    set_move_increments
  end

  def set_move_increments
    if color == :black
      self.slide_increments = [[-1,-1], [-1,1]]
      self.jump_increments = [[-2,-2], [-2,2]]
    else
      self.slide_increments = [[1,-1], [1,1]]
      self.jump_increments = [[2,-2], [2,2]]
    end
  end

  def set_new_pos(new_pos)
    self.position = new_pos
  end

  def slide_moves
    possible_moves(slide_increments)
  end

  def jump_moves
    possible_moves(jump_increments)
  end

  def possible_moves(increments)

    possible_moves = []

    increments.each do |increment|
      row = position[0] + increment[0]
      col = position[1] + increment[1]
      possible_move = [row, col]
      possible_moves << possible_move if within_board?(possible_move)
    end

    possible_moves
  end

  def within_board?(pos)
    (0...8).to_a.include?(pos[0]) && (0...8).to_a.include?(pos[1])
  end

end