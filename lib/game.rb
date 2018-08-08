

class Game

  attr_accessor :board, :player_1, :player_2

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
    position_number = self.current_player.move(self.board) #=> Returns a position number to be entered into the board
    if self.board.valid_move?(position_number) #=> Checks to see if the position is valid in the current board
      self.board.update(position_number, self.current_player) #=> If ^ is true, updates the board with the player's token ("X", "O")
    else
      puts "Invalid" #=> If ^ is not true, puts out "Invalid"
    end
  end

  #def turn
  #  loop do
  #  puts "Please enter 1-9:"
  #  position_number = self.current_player.move(self.board)
  #  if self.board.valid_move?(position_number)
  #    self.current_player.move(self.board)
  #    break
  #  end
  #  end
  #end


end
