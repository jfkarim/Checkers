class Checkers

  attr_accessor :game_board, :player1, :player2, :game_board

  def initialize
    self.game_board = Board.new
    self.player1 = nil
    self.player2 = nil
    set_players
    @current_player = nil
  end

  def set_players
    self.player1 = Player.new('red')
    self.player2 = Player.new('black')
  end

  def change_players
    @current_player == player1 ? @current_player = player2 : @current_player = player1
  end

end