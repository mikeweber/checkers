class Board
  include IBoard
  
  public
  
  def initialize
    @cols = []
    8.times do
      self.cols << Array.new(8)
    end
  end
  
  def piece_at(col, row)
    return false unless col_array = self.cols[col]
    
    col_array[row]
  end
  
  def remove_piece_from(col, row)
    place_piece_at(col, row, nil)
  end
  
  def place_piece_at(col, row, piece)
    return false if !piece.nil? && square_occupied?(col, row)
    
    self.cols[col][row] = piece
  end
  
  def square_occupied?(col, row)
    !self.cols[col][row].nil?
  end
  
  private
  
  def legal_position?(col, row)
    col_array = self.cols[col]
  end
end
