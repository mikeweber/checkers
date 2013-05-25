class Player
  attr_accessor :direction, :color
  attr_reader :name, :pieces, :board, :lost
  
  def initialize(name)
    @name   = name
    @pieces = []
    @lost   = nil
    @color  = nil
  end
  
  def setup_board(board, first_row = 0)
    @board = board
    3.times do |i|
      set_row_of_pieces(first_row + i)
    end
  end
  
  def add_piece(col, row)
    new_piece = Piece.new(self, self.board, col, row)
    self.pieces << new_piece
    
    return new_piece
  end
  
  def lose_piece(piece)
    piece.remove!
    self.pieces.delete(piece)
    you_lose! if self.pieces.empty?
  end
  
  def make_move
    raise NotImplementedError, "#{__caller__} is not implemented"
  end
  
  def lost?
    @lost.nil? ? self.available_moves.empty? : @lost
  end
  
  def you_win!
    @lost = false
  end
  
  def you_lose!
    @lost = true
  end
  
  def available_moves
    filtered_moves.collect { |move| move.position }.uniq
  end
  
  private
  
  def filtered_moves
    has_jump? ? piece_moves.select { |move| move.jump? } : piece_moves
  end
  
  def has_jump?
    raise piece_moves.inspect if $do_it
    piece_moves.any? { |move| move.jump? }
  end
  
  def piece_moves
    self.pieces.collect do |piece|
      piece.available_moves
    end.flatten
  end
  
  def set_row_of_pieces(row)
    offset = row.even? ? 1 : 0
    4.times do |i|
      self.add_piece(offset + i * 2, row)
    end
  end
end
