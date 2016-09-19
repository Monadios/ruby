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
      puts "Vil du fortsætte?"
      input = gets.chomp.strip

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
  attr_accessor :cur_player, :cur_round, :rounds, :p1, :p2, :state

  def initialize(p1, p2)
    @p1 = p1
    @p2 = p2
    @cur_player = (rand(2) == 0 ? @p1 : @p2)
    @state = { "p1" => {}, "p2" => {} }
    @rounds = rounds
    @cur_round = 0
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

class Menu
  attr_accessor :options

  def initialize(options)
    @options = options
  end

  def ask(prompt)
    puts prompt
    return gets.chomp.strip
  end

  def show_options()
    @options.each_pair do |k,v|
      puts "#{k}: #{v}"
    end
  end

  def handle_selection(sym)
    case sym
    when :aivai
      return AI.new("HAL", :high), AI.new("Marvin", :low)
    when :pvp
      return Player.new(ask("Spiller 1 navn? ")), Player.new(ask("Spiller 2 navn? "))
    when :pvai
      return Player.new(ask("Spiller navn? ")), AI.new("HAL", :high)
    when :exit
      Kernel.exit(0)
    else
      :not_found
    end
  end

  def run_menu
    choice = :not_found
    while choice == :not_found
      show_options
      input = ask("Vælg en mulighed: ").downcase.to_sym
      choice = handle_selection input
    end
    return choice
  end
end

def main
  options = {
             :aivai => "AI vs AI",
             :pvp   => "Player vs Player",
             :pvai  => "Player vs AI"
            }
  menu = Menu.new(options)
  players = menu.run_menu
  board = Board.new(players[0], players[1])
  board.play
end

main
