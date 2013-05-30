require 'spec_helper'

describe Game do
  let(:game)    { Game.new(player1, player2) }
  let(:player1) { Player.new(1) }
  let(:player2) { Player.new(2) }
  
  before(:each) do
    # initialize game
    game
  end
  
  context "when determing if the game is over" do
    it "should be over when a player is out of pieces" do
      (player1.pieces.size - 1).times do |i|
        player1.lose_piece(player1.pieces[0])
      end
      expect {
        player1.lose_piece(player1.pieces[0])
      }.to change(game, :playing?).from(true).to(false)
    end
    
    it "should be over when the take_turn method raises and EndGame exception" do
      game.should_receive(:take_turn).and_raise(EndGame.new)
      expect {
        game.play!
      }.to change(game, :playing?).from(true).to(false)
    end
    
    it "should be over when a player is prevented from making any moves" do
      # remove all player1 pieces except from the corner
      pieces = player1.pieces.clone
      pieces.each do |piece|
        player1.lose_piece(piece) unless piece.position == [7, 0]
      end
      player1.pieces.size.should == 1
      
      # Mock moving a piece into place to prevent a jump
      player2.add_piece(5, 2)
      expect {
        expect {
          player2.add_piece(6, 1)
        }.to change { player1.available_moves.empty? }.from(false).to(true)
      }.to change(game, :playing?).from(true).to(false)
    end
  end
  
  context "when a jump is available" do
    it "should only allow the player to make a jump" do
      # once a jump becomes possible, the player's only move should be that jump
      expect {
        expect {
          player2.add_piece(4, 3)
        }.to change(player1, :has_jump?).from(false).to(true)
      }.to change { player1.moveable_pieces.size }.to(2)
    end
    
    it "should not allow a player to move a piece that does not have a jump" do
      player2.add_piece(4, 3)
      player1.should be_has_jump
      
      non_jump_ready_piece = player1.pieces.detect { |piece| piece.position == [1, 2] }
      player1.moveable_pieces.should_not include(non_jump_ready_piece)
      
      lambda { player1.pieces.detect { |piece| piece.position == [1, 2] }.move_to(0, 3) }.should raise_error
      expect {
        player1.pieces.detect { |piece| piece.position == [3, 2] }.move_to(5, 4)
      }.to change { player2.pieces.size }.by(-1)
    end
    
    it "should let the player make one jump when available" do
      # setup a situation with a single jump
      player2.add_piece(6, 3)
      game.send(:whose_turn=, player1)
      
      expect {
        piece = player1.pieces.detect { |piece| piece.position == [7, 2] }
        game.toggle_turn piece, piece.move_to(5, 4)
      }.to change(game, :whose_turn).to(player2)
    end
    
    it "should let the player make multiple jumps" do
      # setup a situation with multiple jumps
      player2.add_piece(6, 3)
      landing_piece = player2.pieces.detect { |piece| piece.position == [7, 6] }
      player2.lose_piece(landing_piece)
      
      game.send(:whose_turn=, player1)
      expect {
        piece = player1.pieces.detect { |piece| piece.position == [7, 2] }
        game.toggle_turn piece, piece.move_to(5, 4)
      }.to_not change(game, :whose_turn)
      expect {
        piece = player1.pieces.detect { |piece| piece.position == [5, 4] }
        game.toggle_turn piece, piece.move_to(7, 6)
      }.to change(game, :whose_turn).to(player2)
    end
    
    it "should not let a piece make multiple jumps on the same turn it is kinged" do
      # setup a situation where a player can jump to get kinged, and have another jump available after
      player1.pieces.detect { |piece| piece.position == [1, 2] }.remove!
      player1.pieces.detect { |piece| piece.position == [3, 0] }.remove!
      player1.pieces.detect { |piece| piece.position == [5, 2] }.remove!
      
      game.send(:whose_turn=, player2)
      piece = player2.add_piece(1, 2)
      expect {
        expect {
          player2.should be_has_jump
          game.toggle_turn(piece, piece.move_to(3, 0))
          player2.should be_has_jump
        }.to change(piece, :kinged?).from(false).to(true)
      }.to change(game, :whose_turn).from(player2).to(player1)
    end
    
    it "should let a piece make multiple jumps on the same turn it reaches the end and is already kinged" do
      # setup a situation where a player can jump to get kinged, and have another jump available after
      player1.pieces.detect { |piece| piece.position == [1, 2] }.remove!
      player1.pieces.detect { |piece| piece.position == [3, 0] }.remove!
      player1.pieces.detect { |piece| piece.position == [5, 2] }.remove!
      
      game.send(:whose_turn=, player2)
      piece = player2.add_piece(1, 2)
      piece.king_me!
      expect {
        expect {
          player2.should be_has_jump
          game.toggle_turn(piece, piece.move_to(3, 0))
          player2.should be_has_jump
        }.to_not change(piece, :kinged?).from(true)
      }.to_not change(game, :whose_turn).from(player2)
    end
    
    it "should only allow the same piece to make multiple jumps" do
      # setup a situation where 2 pieces can make a jump, do the jump, and confirm the turn is over
      player1.pieces.detect { |piece| piece.position == [2, 1] }.remove!
      player1.pieces.detect { |piece| piece.position == [4, 1] }.remove!
      
      piece1 = player2.add_piece(0, 3)
      piece2 = player2.add_piece(6, 3)
      
      game.send(:whose_turn=, player2)
      expect {
        game.toggle_turn(piece1, piece1.move_to(2, 1))
      }.to change(game, :whose_turn).from(player2).to(player1)
    end
  end
end
