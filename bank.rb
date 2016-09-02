class Player
  attr_accessor :bank, :name

  def initialize(name)
    @bank = 0
    @name = name
  end

  def player_turn
    temp_sum = 0
    dice = 0
    while true
      input = gets.chomp
     
      if validate_input input
        dice = roll_dice
        puts "Du rullede #{dice}"

        if dice > 1 and dice < 7
          temp_sum += dice
          puts "Midlertidige sum: #{temp_sum}"
        else
          puts "Midlertidige sum nulstillet"
          temp_sum = 0
          break
        end        
      else
        @bank += temp_sum
        break
      end
    end
    puts "#{@name}'s sum er nu #{@bank}\n"
  end

  def roll_dice
    return 1 + rand(6)
  end

  private :roll_dice
  
  def validate_input(input)
    valid_inputs = ["yes", "y", "ja"]
    return valid_inputs.include? input 
  end
end

class AI
  attr_accessor :bank, :name

  def initialize(name)
    @bank = 0
    @name = name
  end

  def player_turn
    temp_sum = 0
    dice = 0
    avg_dice = 0
    turn_number = 1
    while true
      if want_to_move(temp_sum)
        dice = roll_dice
        puts "Computeren \"#{@name}\" rullede #{dice}"

        if dice > 1 and dice < 7
          temp_sum += dice
          avg_dice = (avg_dice + dice) / turn_number
          turn_number += 1
          puts "Midlertidige sum: #{temp_sum}"
        else
          puts "Midlertidige sum nulstillet"
          temp_sum = 0
          break
        end        
      else
        @bank += temp_sum
        break
      end
    end
    puts "Computeren \"#{@name}\"'s sum er nu #{@bank}\n"
  end

  def roll_dice
    return 1 + rand(6)
  end

  private :roll_dice

  def want_to_move(temp_sum)
    rand(2) == 0
    #TODO
    # add better strategy
    # algorithm = while risk < reward
    # risk = turn/6
    # reward = average reward
  end

  protected :want_to_move
    
end

class Board
  attr_accessor :cur_player, :p1, :p2

  def initialize(p1, p2)
    @p1 = p1
    @p2 = p2
    @cur_player = (rand(2) == 0 ? @p1 : @p2)
  end

  def show_cur_player
    puts @cur_player.name
  end

  def switch_player()
    @cur_player = (@cur_player == p1 ? p2 : p1)
  end
  
  def play
    while true
      show_cur_player
      @cur_player.player_turn
      if(@cur_player.bank >= 100)
        puts "#{@cur_player.name} vandt"
        Kernel.exit(0)
      else
        switch_player
      end
    end
  end
end

p1 = Player.new "G"
p2 = AI.new "HAL"

board = Board.new p1, p2
board.play
