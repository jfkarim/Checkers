class Tile

  def initialize(piece = nil)
    self.piece = piece
  end

  def no_piece?
    piece.nil?
  end

  def occupied_by_enemy?(color)
    return false if no_piece?
    piece.color != color
  end

  def occupied_by_teammate?(color)
    return false if no_piece?
    piece.color == color
  end

end