# encode utf-8
class Game
  protected
  attr_accessor :board
  attr_reader :red, :black
  
  public
  
  def initialize(player1, player2)
    setup_game(player1, player2)
  end
  
  def setup_game(player1, player2)
    @red = player1
    @black = player2
    
    setup_board
  end
  
  def setup_board
    @board = Board.new
    
    self.red.direction, self.black.direction = [:asc, :desc]
    self.red.color, self.black.color = [:red, :black]
    
    self.red.setup_board(self.board, 0)
    self.black.setup_board(self.board, 5)
  end
  
  def play!
    whose_turn = self.black
    while playing?
      whose_turn.make_move
      whose_turn = whose_turn == self.black ? self.red : self.black
    end
    
    if self.red.lost?
      self.black.you_win!
    elsif self.black.lost?
      self.red.you_win!
    end
  end
  
  def playing?
    !self.red.lost? && !self.black.lost?
  end
end
