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
  
  def direction
    self.player.direction
  end
  
  def color
    self.player.color
  end
  
  def move_to(col, row)
    raise "Illegal move" unless inbounds?([col, row])
    raise "Not a moveable piece" unless self.can_move?
    
    remove!
    jump_result = jump_piece(self.position, [col, row])
    place_at(col, row)
    jump_result &= !king_me! if at_opposite_end?
    
    return jump_result
  end
  
  def jump_piece(pos1, pos2)
    return false unless move_is_jump?(pos1, pos2)
    
    jumped_piece = self.board.piece_at((pos1[0] + pos2[0]) / 2, (pos1[1] + pos2[1]) / 2)
    jumped_piece.player.lose_piece(jumped_piece)
    jumped_piece.remove!
    return true
  end
  
  def move_is_jump?(pos1, pos2)
    (pos1[1] - pos2[1]).abs == 2
  end
  
  def remove!
    self.board.remove_piece_from(*self.position)
  end
  
  def legal_moves_as_coordinates
    self.legal_moves.collect { |move| move.position }
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
  
  def can_move?
    self.player.has_jump? == self.has_jump?
  end
  
  def has_move?
    !self.legal_moves.empty?
  end
  
  def legal_moves
    self.has_jump? ? jump_moves : available_moves
  end
  
  def has_jump?
    available_moves.any? { |move| move.jump? }
  end
  
  private
  
  def jump_moves
    available_moves.select { |move| move.jump? }
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
  
  def place_at(col, row)
    raise "Board must be set" if self.board.nil?
    self.board.place_piece_at(@col = col, @row = row, self)
  end
  
  def inbounds?(position)
    0 <= position.min && position.max <= 7
  end
  
  def at_opposite_end?
    self.position[1] == ((player.direction == :asc) ? 7 : 0)
  end
end
