class Piece
  attr_reader :direction, :color
  
  protected 
  attr_reader :board
  attr_accessor :kinged
  
  public
  
  def initialize(direction, color, board, col, row)
    @direction = direction
    @color     = color
    @board     = board
    @kinged    = false
    place_at(col, row)
  end
  
  def move_to(col, row)
    raise "Illegal move" unless inbounds?([col, row])
    remove!
    place_at(col, row)
  end
  
  def remove!
    self.board.remove_piece_from(*self.position)
  end
  
  def available_moves_as_coordinates
    self.available_moves.collect { |move| move.position }
  end
  
  def available_moves
    moves = []
    offset = direction == :desc ? -1 : 1
    possible_offsets = [[-1, offset], [1, offset]]
    possible_offsets += [[-1, -offset], [1, -offset]] if self.kinged?
    possible_offsets.select! do |offsets|
      pos = []
      self.position.zip(offsets) { |a, b| pos << a + b }
      inbounds?(pos)
    end
    
    possible_offsets.each do |offsets|
      pos = []
      self.position.zip(offsets) { |a, b| pos << a + b }
      piece_at_pos = self.board.piece_at(*pos)
      
      landing = []
      self.position.zip(offsets) { |a, b| landing << a + 2 * b }
      piece_at_landing = self.board.piece_at(*landing)
      
      if piece_at_pos.nil?
        moves << Move.new(pos, false)
      elsif !self.friend?(piece_at_pos) && inbounds?(landing) && piece_at_landing.nil?
        moves << Move.new(landing, true)
      end
    end
    
    return moves
  end
  
  Move = Struct.new(:position, :jump) do
    def jump?
      jump
    end
  end
  
  def position
    [@col, @row]
  end
  
  # Identify Friend from Foe
  def friend?(piece)
    self.direction == piece.direction
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
  
  def inbounds?(position)
    0 <= position.min && position.max <= 7
  end
end
