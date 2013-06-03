require 'spec_helper'

describe Player do
  subject        {
    player.setup_board(board, :asc)
    player
  }
  let(:player)   { Player.new("Tester") }
  let(:board)    { Board.new }
  let(:opponent) {
    opp = Player.new("AI")
    opp.setup_board(board, :desc)
    opp
  }
  
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
    # initialize subject
    subject
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
  
  it "should lose the game when it loses all of its pieces" do
    (subject.pieces.size - 1).times do |i|
      subject.lose_piece(subject.pieces[0])
    end
    expect {
      subject.lose_piece(subject.pieces[0])
    }.to change(subject, :lost?).from(false).to(true)
  end
  
  it "should know its available moves" do
    subject.available_moves.should =~ [[0, 3], [2, 3], [4, 3], [6, 3]]
  end
  
  it "should only be allowed to make jumps when they're availble" do
    # have the opponent move a piece that's jumpable by a piece
    opponent.add_piece(2, 3)
    subject.available_moves.should =~ [[1, 4], [3, 4]]
  end
  
  it "should lose when it has no available moves" do
    (subject.pieces.size - 1).times do |i|
      subject.lose_piece(subject.pieces[0])
    end
    
    subject.available_moves.should_not be_empty
    subject.lose_piece(subject.pieces[0])
    subject.available_moves.should be_empty
    
    subject.should be_lost
  end
  
  it "should take the opponent's piece after a jump" do
    # clear the board and setup a jump situation
    subject.pieces.size.times { subject.lose_piece(subject.pieces[0]) }
    opponent.pieces.size.times { opponent.lose_piece(opponent.pieces[0]) }
    
    subject.add_piece(2, 3)
    opponent.add_piece(3, 4)
    
    expect {
      subject.pieces[0].move_to(4, 5)
    }.to change(opponent.pieces, :size).by(-1)
  end
end
