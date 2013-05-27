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
    
    context "when a jump is available" do
      it "should only allow the player to make a jump" do
        # once a jump becomes possible, the player's only move should be that jump
        expect {
          expect {
            player2.add_piece(4, 3)
          }.to change(player1, :has_jump?).from(false).to(true)
        }.to change { player1.available_moves.size }.to(2)
      end
      
      it "should let the player make multiple jumps" do
        # setup a situation with multiple jumps
        player2.add_piece(6, 3)
        landing_piece = player2.pieces.detect { |piece| piece.position == [7, 6] }
        player2.lose_piece(landing_piece)
        
        game.send(:whose_turn=, player1)
        expect {
          game.toggle_turn player1.pieces.detect { |piece| piece.position == [7, 2] }.move_to(5, 4)
        }.to_not change(game, :whose_turn)
        expect {
          game.toggle_turn player1.pieces.detect { |piece| piece.position == [5, 4] }.move_to(7, 6)
        }.to change(game, :whose_turn).to(player2)
      end
    end
  end
end
