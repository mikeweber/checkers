module IBoard
  attr_reader :cols
  
  def piece_at(col, row)
    not_implemented
  end
  
  def place_piece_at(col, row, piece)
    not_implemented
  end
  
  def space_occupied?(col, row)
    not_implemented
  end
  
  private
  
  def not_implemented
    raise NotImplementedError, "#{__caller__} is not implemented"
  end
end
