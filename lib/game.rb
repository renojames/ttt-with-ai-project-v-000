

class Game

  attr_accessor :board, :player_1, :player_2, :avail_moves

  WIN_COMBINATIONS = [
  [0, 1, 2],
  [3, 4, 5],
  [6, 7, 8],
  [0, 3, 6],
  [1, 4, 7],
  [2, 5, 8],
  [0, 4, 8],
  [2, 4, 6]
  ]

  def initialize(player_1 = Players::Human.new("X"), player_2 = Players::Human.new("O"), board = Board.new)
    @player_1 = player_1
    @player_2 = player_2
    @board = board
    @avail_moves = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    player_1.game = self
    player_2.game = self
  end

  def current_player
    pcount = board.turn_count + 1
    if pcount.odd?
      player_1
    elsif pcount.even?
      player_2
    end
  end

  def won?
    WIN_COMBINATIONS.each do |win_combination|
      win_index_1 = win_combination[0]
      win_index_2 = win_combination[1]
      win_index_3 = win_combination[2]

      position_1 = board.cells[win_index_1]
      position_2 = board.cells[win_index_2]
      position_3 = board.cells[win_index_3]
      if (position_1 == "X" && position_2 == "X" && position_3 == "X") || (position_1 == "O" && position_2 == "O" && position_3 == "O")
        return win_combination
      end
    end
    return false
  end

  def draw?
    !self.won? && board.full?
  end

  def over?
    self.won? || self.draw?
  end

  def winner
    result = self.won?
    if result
      if board.cells[result[0]] == "X"
        return "X"
      else
        return "O"
      end
    end
  end

  def turn
    loop do
      position_number = self.current_player.move(self.board) #=> Returns a position number to be entered into the board
      self.avail_moves.delete(position_number)
      if !self.board.valid_move?(position_number) #=> Checks to see if the position is valid in the current board
        self.avail_moves.delete(position_number)
        puts "Invalid" #=> If ^ is not true, puts out "Invalid"
      else
        self.board.update(position_number, self.current_player) #=> If ^ is true, updates the board with the player's   token ("X", "O")
        break
      end
    end
  end

  def play
    until self.over?
      self.turn
      board.display
    end

    if self.won?
      puts "Congratulations #{winner}!"
      puts ""
    else
      puts "Cat's Game!"
      puts ""
    end
  end

  def self.start
    loop do #start of game loop
      puts ""
      puts "Welcome to Tic-Tac-Toe!"
      puts ""
      puts "Would you like to play against a friend, a computer, or do you want to watch a robot battle?"

      loop do # beginning of choose-game-type loop
        puts "If you want to play with a friend, enter 'friend'."
        puts "If you want to play against a computer, enter 'computer'."
        puts "If you want to want to watch a robot battle, enter 'skynet'."
        puts ""


        game_type = gets.chomp
        if game_type == "friend"
          game = self.new(player_1 = Players::Human.new("X"), player_2 = Players::Human.new("O"), board = Board.new)
          puts ""
          puts "The first player will be 'X'"
          game.board.example_display
          game.play
          break
        elsif game_type == "computer"
          game = self.new(Players::Human.new("X"), Players::Computer.new("O"), Board.new)
          game.board.example_display
          game.play
          break
        elsif game_type == "skynet"
          game = self.new(Players::Computer.new("X"), Players::Computer.new("O"), Board.new)
          game.board.display
          game.play
          break
        else
          puts ""
          puts "***That is not a valid game type!***"
          puts ""
        end # end of 'if'statement
      end # end of choose-game-type loop
      choice = self.play_again?
      if choice == false
        break
      end
    end # end game loop
    puts ""
    puts "Goodbye!"
    puts ""
  end

  def self.play_again?
    loop do # beginning of play again? loop
      puts "Play again? Enter 'yes' or 'no'."
      puts ""
      choice = gets.chomp
      if choice == "yes"
        return true
        break
      elsif choice == "no"
        return false
        break
      else
        puts ""
        puts "Sorry, I didn't understand that!"
        puts ""
      end
    end # end of play again? loop
  end


end
