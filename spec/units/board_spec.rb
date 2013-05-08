require 'spec_helper'

describe Board do
  subject { Board.new }
  
  it "should know what's on the square" do
    expect {
      subject.place_piece_at(3, 1, 'X')
    }.to change { subject.piece_at(3, 1) }.from(nil).to('X')
    
    subject.piece_at(4, 1).should be_nil
  end
  
  it "should be able to remove pieces from squares" do
    subject.place_piece_at(3, 1, 'X')
    expect {
      subject.remove_piece_from(3, 1)
    }.to change { subject.piece_at(3, 1) }.from('X').to(nil)
  end
  
  it "should return false when asking for an out of bounds location" do
    subject.piece_at(7, 7).should be_nil
    subject.piece_at(8, 7).should be_false
    subject.piece_at(7, 8).should be_false
  end
  
  it "should not allow a 'piece' to be placed on the same square as another 'piece'" do
    expect {
      subject.place_piece_at(3, 1, 'X')
    }.to change { subject.piece_at(3, 1) }.from(nil).to('X')
    expect {
      subject.place_piece_at(3, 1, 'Y').should be_false
    }.to_not change { subject.piece_at(3, 1) }.from(nil).to('X')
  end
end
