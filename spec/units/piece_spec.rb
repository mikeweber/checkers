require 'spec_helper'

describe Piece do
  subject          { piece }
  let(:piece)      { Piece.new(my_team, board, 0, 0) }
  let(:board)      { Board.new }
  let(:my_team)    { 1 }
  let(:other_team) { 0 }
  
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
    enemy_piece = Piece.new(other_team, board, 1, 1)
    friendly_piece = Piece.new(my_team, board, 2, 0)
    
    subject.friend?(enemy_piece).should be_false
    subject.friend?(friendly_piece).should be_true
  end
  
  it "should be able to be 'kinged'" do
    expect {
      piece.king_me!
    }.to change(piece, :kinged?).from(false).to(true)
  end
end
