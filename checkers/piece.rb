class Piece
  attr_reader :player
  
  protected 
  attr_reader :board
  attr_accessor :kinged
  
  public
  
  def initialize(player, board, col, row)
    @player = player
    @board  = board
    @kinged = false
    place_at(col, row)
  end
  
  def move_to(col, row)
    remove!
    place_at(col, row)
  end
  
  def remove!
    self.board.remove_piece_from(*self.position)
  end
  
  def position
    [@col, @row]
  end
  
  # Identify Friend from Foe
  def friend?(piece)
    self.player == piece.player
  end
  
  def king_me!
    return false if kinged?
    
    self.kinged = true
  end
  
  def kinged?
    self.kinged
  end
  
  private
  
  def place_at(col, row)
    raise "Board must be set" if self.board.nil?
    self.board.place_piece_at(@col = col, @row = row, self)
  end
end
