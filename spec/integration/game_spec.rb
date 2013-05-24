require 'spec_helper'

describe Game do
  let(:game)    { Game.new(player1, player2) }
  let(:player1) { Player.new(1) }
  let(:player2) { Player.new(2) }
  
  context "when determing if the game is over" do
    before(:each) do
      # initialize game
      game
    end
    
    it "should be over when a player is out of pieces" do
      (player1.pieces.size - 1).times do |i|
        player1.lose_piece(player1.pieces[0])
      end
      expect {
        player1.lose_piece(player1.pieces[0])
      }.to change(game, :playing?).from(true).to(false)
    end
  end
end
