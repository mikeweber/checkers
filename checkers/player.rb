class Player
  attr_reader :name, :pieces, :board
  
  def initialize(name)
    @name   = name
    @pieces = []
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
  end
  
  private
  
  def set_row_of_pieces(row)
    offset = row.even? ? 1 : 0
    4.times do |i|
      self.add_piece(offset + i * 2, row)
    end
  end
end
