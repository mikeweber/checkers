require 'spec_helper'

describe Player do
  subject      { 
    player.board = board
    player
  }
  let(:player) { Player.new("Tester") }
  let(:board)  { Board.new }
  
  it "requires that a board be set before placing a piece" do
    player.board.should be_nil
    lambda { player.add_piece(0, 0) }.should raise_error
  end
  
  it "should be able to place a piece on the board" do
    expect {
      subject.add_piece(0, 0)
    }.to change { board.square_occupied?(0, 0) }.from(false)
  end
  
  it "should keep track of its pieces" do
    expect {
      subject.add_piece(0, 0)
      subject.add_piece(2, 0)
      subject.add_piece(4, 0)
    }.to change(player.pieces, :size).by(3)
  end
  
  it "should be able to lose a piece" do
    piece = nil
    expect {
      piece = subject.add_piece(0, 0)
    }.to change(subject.pieces, :size).by(1)
    
    expect {
      subject.lose_piece(piece)
    }.to change(subject.pieces, :size).by(-1)
  end
end
