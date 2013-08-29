class Piece
  attr_accessor :color, :position, :move_increments, :jump_increments


  def initialize(color, position)
    self.color = color
    self.position = position
    set_move_increments
  end

  def set_move_increments
    if color == 'black'
      self.move_increments = [[-1,-1], [-1,1]]
      self.jump_increments = [[-2,-2], [-2,2]]
    else
      self.move_increments = [[1,-1], [1,1]]
      self.jump_increments = [[2,-2], [2,2]]
    end
  end

  def set_new_pos(new_pos)
    self.position = new_pos
  end

  def possible_moves
    possible_moves = []

    move_increments.each do |increment|
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