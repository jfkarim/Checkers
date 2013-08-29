class King < Piece
  attr_accessor :color, :position, :slide_increments, :jump_increments, :type


  def initialize(color, position, type = :king)
    self.color = color
    self.position = position
    set_move_increments
  end

  def set_move_increments
    self.slide_increments = [[-1,-1], [-1,1], [1,-1], [1,1]]
    self.jump_increments = [[-2,-2], [-2,2], [2,-2], [2,2]]
  end

end