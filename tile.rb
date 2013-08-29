class Tile
  attr_accessor :piece

  def initialize(piece = nil)
    self.piece = piece
  end

  def no_piece?
    piece.nil?
  end

end