# encode utf-8
class Game
  protected
  attr_accessor :board
  attr_reader :white, :black
  
  public
  
  def initialize(player1, player2)
    @white = player1
    @black = player2
    
    setup_board
  end
  
  def setup_board
    @board = Board.new
    
    self.white.setup_board(self.board, 0)
    self.black.setup_board(self.board, 5)
  end
  
  def to_s
    output = "  0|1|2|3|4|5|6|7\n"
    
    8.times do |row|
      output << "#{row}|"
      self.board.cols.each.with_index do |column, col|
        piece = column[row]
        char = piece.nil? ? ((col + row).odd? ? ' ' : '█') : (piece.player == self.white) ? (piece.kinged? ? '◎' : '○') : (piece.kinged? ? '◉' : '●')
        output << "#{char}|"
      end
      output << "\n"
    end
    
    return output
  end
end
