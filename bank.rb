# -*- coding: utf-8 -*-
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
      
      if want_to_move input
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
  
  def want_to_move(input)
    valid_pos = ["yes", "y", "ja"] #all the "yes" values
    return valid_pos.include? input
  end
end

class AI
  attr_accessor :bank, :name, :iq

  def initialize(name, iq)
    @bank = 0
    @name = name
    @iq = iq
  end

  def player_turn(print=true)
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
    should_stop = 0
    if iq == :high then should_stop = case temp_sum #the chance of stopping the turn
                                      when (0..5) then 6
                                      when (5..10) then 4
                                      when (10..20) then 3
                                      else 2
                                      end
    elsif iq == :low
      should_stop = 3
    end
    return rand(should_stop) != 0
  end

  protected :want_to_move
  
end

class Board
  attr_accessor :cur_player, :players, :menu

  def initialize(players, menu)
    @menu = menu
    @players = @menu.start_menu
    @cur_player = players[rand(players.length)]
  end
  
  def show_cur_player
    puts @cur_player.name
  end
  
  def switch_player()
    temp = @players.pop # remove the current player
    @players.unshift temp #prepend player to list
    @cur_player = @players[0]
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

class Menu
  attr_accessor :options

  def initialize(options)
    @options = options
  end

  def show_options()
    @options.each_pair do |k,v|
      puts "#{k}: #{v}"
    end
  end

  def create_option(str)
    return str.downcase.gsub(/[^a-z0-9\s]/i, "").gsub(/\s+/, "_").to_sym
  end

  
  def select_options(sym)
    players = []
    return :not_found unless @options.has_key? sym
    mode = (@options.assoc sym)[0]

    case mode
    when :aivai
      players[0] = AI.new("HAL", :high)
      players[0] = AI.new("Marvin", :low)
    when :pvp
      puts "Spiller 1 navn?"
      players[0] = Player.new(gets.chomp)
      puts "Spiller 2 navn?"
      players[1] = Player.new(gets.chomp)
    when :pvai
      puts "Spiller navn?"
      players[0] = Player.new(gets.chomp)
      players[1] = AI.new("HAL", :high)
    when :exit
      Kernel.exit(0)
    end

    return players
  end
  
  def options=(opts)
    @options = opts
  end

  def start_menu
    input = ""
    while true
      show_options
      input = create_option gets.chomp
      selection = select_options(input)
      return selection if selection != :not_found
    end
  end
end


def main
  options =  {
              :aivai => "AI vs AI",
              :pvp   => "Player vs Player",
              :pvai  => "Player vs AI",
              :exit => "Exit"
             }
   
  menu = Menu.new(options)
  board = Board.new(menu)
  board.play
end
