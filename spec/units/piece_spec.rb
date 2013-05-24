require 'spec_helper'

describe Piece do
  subject     { piece }
  let(:piece) { Piece.new(desc, :black, board, 0, 0) }
  let(:board) { Board.new }
  let(:desc)  { :desc }
  let(:asc)   { :asc }
  
  it "should know where it is on the Board" do
    subject.position.should == [0, 0]
  end
  
  it "should be able to move to a new position" do
    expect {
      subject.move_to(1, 1)
    }.to change(subject, :position).from([0, 0]).to([1, 1])
  end
  
  context "after a move" do
    it "should tell the board where it is" do
      expect {
        expect {
          subject.move_to(1, 1)
        }.to change { board.piece_at(1, 1) }.from(nil).to(subject)
      }.to change { board.piece_at(0, 0) }.from(subject).to(nil)
    end
  end
  
  it "should know friend from foe" do
    enemy_piece = Piece.new(asc, :red, board, 1, 1)
    friendly_piece = Piece.new(desc, :black, board, 2, 0)
    
    subject.friend?(enemy_piece).should be_false
    subject.friend?(friendly_piece).should be_true
  end
  
  it "should be able to be 'kinged'" do
    expect {
      piece.king_me!
    }.to change(piece, :kinged?).from(false).to(true)
  end
  
  context "when determining legal moves" do
    it "should be able to move forward into available squares" do
      Piece.new(desc, :black, board, 1, 6).available_moves_as_coordinates.should =~ [[0, 5], [2, 5]]
    end
    
    it "should not be able to move off the board" do
      piece = Piece.new(desc, :black, board, 0, 7)
      piece.available_moves_as_coordinates.should =~ [[1, 6]]
      piece.available_moves_as_coordinates.should_not include([-1, 6])
    end
    
    it "should not be able to move more than one space" do
      piece = Piece.new(desc, :black, board, 0, 1)
      piece.available_moves_as_coordinates.should_not include([2, 3])
    end
    
    it "should not be able to move backward" do
      piece = Piece.new(desc, :black, board, 3, 6)
      piece.available_moves_as_coordinates.should_not include([2, 7])
    end
    
    it "should not be able to move to a square occupied by a friendly piece" do
      piece = Piece.new(desc, :black, board, 0, 7)
      expect {
        Piece.new(desc, :black, board, 1, 6)
      }.to change(piece, :available_moves_as_coordinates).from([[1, 6]]).to([])
    end
    
    it "should be able to jump an opponent's piece" do
      piece = Piece.new(desc, :black, board, 0, 7)
      expect {
        Piece.new(asc, :red, board, 1, 6)
      }.to change(piece, :available_moves_as_coordinates).from([[1, 6]]).to([[2, 5]])
    end
    
    it "should not be able to jump an opponent's piece when the landing square is occupied" do
      piece = Piece.new(desc, :black, board, 0, 7)
      jumpable_piece = Piece.new(asc, :red, board, 1, 6)
      expect {
        Piece.new(desc, :black, board, 2, 5)
      }.to change(piece, :available_moves_as_coordinates).from([[2, 5]]).to([])
    end
    
    it "should not be able to jump an opponent's piece when the landing is off the board" do
      piece = Piece.new(desc, :black, board, 1, 6)
      expect {
        Piece.new(asc, :red, board, 0, 5)
      }.to change(piece, :available_moves_as_coordinates).from([[0, 5], [2, 5]]).to([[2, 5]])
      
      piece = Piece.new(desc, :black, board, 6, 6)
      expect {
        Piece.new(asc, :red, board, 7, 5)
      }.to change(piece, :available_moves_as_coordinates).from([[5, 5], [7, 5]]).to([[5, 5]])
    end
    
    context "when kinged" do
      it "should be able to move backward" do
        piece = Piece.new(desc, :black, board, 1, 5)
        expect {
          piece.king_me!
        }.to change(piece, :available_moves_as_coordinates).from([[0, 4], [2, 4]]).to([[0, 4], [2, 4], [0, 6], [2, 6]])
      end
    end
  end
end
