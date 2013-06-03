require 'spec_helper'

describe Piece do
  subject     { piece }
  let(:piece) { player.pieces.detect { |piece| piece.position == [1, 2] } }
  let(:board) { Board.new }
  let(:player){
    p = Player.new("Us")
    p.setup_board(board, :asc)
    p
  }
  let(:opp)   {
    p = Player.new("Them")
    p.setup_board(board, :desc)
    p
  }
  
  before(:each) do
    player
    opp
  end
  
  it "should know where it is on the Board" do
    subject.position.should == [1, 2]
  end
  
  it "should be able to move to a new position" do
    expect {
      subject.move_to(0, 3)
    }.to change(subject, :position).from([1, 2]).to([0, 3])
  end
  
  context "after a move" do
    it "should tell the board where it is" do
      expect {
        expect {
          subject.move_to(0, 3)
        }.to change { board.piece_at(0, 3) }.from(nil).to(subject)
      }.to change { board.piece_at(1, 2) }.from(subject).to(nil)
    end
    
    it "should return false after a regular move" do
      subject.move_to(0, 3).should be_false
    end
    
    it "should return true after a jump" do
      opp.add_piece(2, 3)
      player.should be_has_jump
      subject.should be_has_jump
      subject.move_to(3, 4).should be_true
    end
  end
  
  it "should know friend from foe" do
    friendly_piece = player.pieces.detect { |piece| piece.position == [7, 2] } 
    enemy_piece    = opp.pieces.detect { |piece| piece.position == [0, 5] } 
    
    subject.friend?(enemy_piece).should be_false
    subject.friend?(friendly_piece).should be_true
  end
  
  it "should be able to be 'kinged'" do
    expect {
      piece.king_me!
    }.to change(piece, :kinged?).from(false).to(true)
  end
  
  it "should become kinged when reaching the other end of the board" do
    piece = Piece.new(player, board, 2, 5)
    expect {
      piece.move_to(1, 6)
    }.to_not change(piece, :kinged?).from(false)
    expect {
      piece.move_to(2, 7)
    }.to change(piece, :kinged?).from(false).to(true)
  end
  
  context "when determining legal moves" do
    it "should be able to move forward into available squares" do
      board.piece_at(2, 5).legal_moves_as_coordinates.should =~ [[3, 4], [1, 4]]
    end
    
    it "should not be able to move off the board" do
      piece = board.piece_at(0, 5)
      piece.legal_moves_as_coordinates.should =~ [[1, 4]]
      piece.legal_moves_as_coordinates.should_not include([-1, 6])
    end
    
    it "should not be able to move more than one space" do
      piece = board.piece_at(0, 5)
      piece.legal_moves_as_coordinates.should_not include([0, 3])
    end
    
    it "should not be able to move backward" do
      piece = board.piece_at(2, 5)
      piece.move_to(3, 4)
      piece.legal_moves_as_coordinates.should_not include([2, 5])
    end
    
    it "should not be able to move to a square occupied by a friendly piece" do
      piece = board.piece_at(3, 6)
      expect {
        board.piece_at(2, 5).remove!
      }.to change(piece, :legal_moves_as_coordinates).from([]).to([[2, 5]])
    end
    
    it "should be able to jump an opponent's piece" do
      piece = board.piece_at(2, 5)
      expect {
        player.add_piece(3, 4)
      }.to change(piece, :legal_moves_as_coordinates).from([[1, 4], [3, 4]]).to([[4, 3]])
    end
    
    it "should be able to make a normal move once a jump is no longer viable" do
      piece = board.piece_at(2, 5)
      jumpable_piece = player.add_piece(3, 4)
      expect {
        opp.add_piece(4, 3)
      }.to change(piece, :legal_moves_as_coordinates).from([[4, 3]]).to([[1, 4]])
    end
    
    it "should not be able to jump an opponent's piece when the landing square is occupied" do
      piece = board.piece_at(0, 5)
      jumpable_piece = player.add_piece(1, 4)
      expect {
        opp.add_piece(2, 3)
      }.to change(piece, :legal_moves_as_coordinates).from([[2, 3]]).to([])
    end
    
    it "should not be able to jump an opponent's piece when the landing is off the board" do
      piece = board.piece_at(6, 5)
      expect {
        player.add_piece(7, 4)
      }.to change(piece, :legal_moves_as_coordinates).from([[5, 4], [7, 4]]).to([[5, 4]])
      
      piece = board.piece_at(1, 2)
      expect {
        opp.add_piece(0, 3)
      }.to change(piece, :legal_moves_as_coordinates).from([[0, 3], [2, 3]]).to([[2, 3]])
    end
    
    context "when kinged" do
      it "should be able to move backward" do
        piece = Piece.new(opp, board, 1, 5)
        expect {
          piece.king_me!
        }.to change(piece, :legal_moves_as_coordinates).from([[0, 4], [2, 4]]).to([[0, 4], [2, 4], [0, 6], [2, 6]])
      end
    end
  end
end
