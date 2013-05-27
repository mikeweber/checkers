require 'spec_helper'

describe Piece do
  subject     { piece }
  let(:piece) { Piece.new(player, board, 1, 0) }
  let(:board) { Board.new }
  let(:player){
    p = Player.new("Us")
    p.direction = :asc
    p.color = :red
    p
  }
  let(:opp)   {
    p = Player.new("Them")
    p.direction = :desc
    p.color = :black
    p
  }
  
  it "should know where it is on the Board" do
    subject.position.should == [1, 0]
  end
  
  it "should be able to move to a new position" do
    expect {
      subject.move_to(0, 1)
    }.to change(subject, :position).from([1, 0]).to([0, 1])
  end
  
  context "after a move" do
    it "should tell the board where it is" do
      expect {
        expect {
          subject.move_to(0, 1)
        }.to change { board.piece_at(0, 1) }.from(nil).to(subject)
      }.to change { board.piece_at(1, 0) }.from(subject).to(nil)
    end
    
    it "should return false after a regular move" do
      subject.move_to(0, 1).should be_false
    end
    
    it "should return true after a jump" do
      Piece.new(opp, board, 2, 1)
      subject.move_to(3, 2).should be_true
    end
  end
  
  it "should know friend from foe" do
    enemy_piece = Piece.new(opp, board, 1, 1)
    friendly_piece = Piece.new(player, board, 2, 0)
    
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
      Piece.new(opp, board, 1, 6).available_moves_as_coordinates.should =~ [[0, 5], [2, 5]]
    end
    
    it "should not be able to move off the board" do
      piece = Piece.new(opp, board, 0, 7)
      piece.available_moves_as_coordinates.should =~ [[1, 6]]
      piece.available_moves_as_coordinates.should_not include([-1, 6])
    end
    
    it "should not be able to move more than one space" do
      piece = Piece.new(opp, board, 0, 1)
      piece.available_moves_as_coordinates.should_not include([2, 3])
    end
    
    it "should not be able to move backward" do
      piece = Piece.new(opp, board, 3, 6)
      piece.available_moves_as_coordinates.should_not include([2, 7])
    end
    
    it "should not be able to move to a square occupied by a friendly piece" do
      piece = Piece.new(opp, board, 0, 7)
      expect {
        Piece.new(opp, board, 1, 6)
      }.to change(piece, :available_moves_as_coordinates).from([[1, 6]]).to([])
    end
    
    it "should be able to jump an opponent's piece" do
      piece = Piece.new(opp, board, 0, 7)
      expect {
        Piece.new(player, board, 1, 6)
      }.to change(piece, :available_moves_as_coordinates).from([[1, 6]]).to([[2, 5]])
    end
    
    it "should not be able to jump an opponent's piece when the landing square is occupied" do
      piece = Piece.new(opp, board, 0, 7)
      jumpable_piece = Piece.new(player, board, 1, 6)
      expect {
        Piece.new(opp, board, 2, 5)
      }.to change(piece, :available_moves_as_coordinates).from([[2, 5]]).to([])
    end
    
    it "should not be able to jump an opponent's piece when the landing is off the board" do
      piece = Piece.new(opp, board, 1, 6)
      expect {
        Piece.new(player, board, 0, 5)
      }.to change(piece, :available_moves_as_coordinates).from([[0, 5], [2, 5]]).to([[2, 5]])
      
      piece = Piece.new(opp, board, 6, 6)
      expect {
        Piece.new(player, board, 7, 5)
      }.to change(piece, :available_moves_as_coordinates).from([[5, 5], [7, 5]]).to([[5, 5]])
    end
    
    context "when kinged" do
      it "should be able to move backward" do
        piece = Piece.new(opp, board, 1, 5)
        expect {
          piece.king_me!
        }.to change(piece, :available_moves_as_coordinates).from([[0, 4], [2, 4]]).to([[0, 4], [2, 4], [0, 6], [2, 6]])
      end
    end
  end
end
