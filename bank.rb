# -*- coding: utf-8 -*-

# Representation of the user
class Player
  attr_accessor :bank, :name

  def initialize(name)
    @bank = 0
    @name = name
  end

  def player_turn
    dump = []
    temp_sum = 0
    dice = 0
    loop do
      input = gets.chomp

      if want_to_move? input
        dice = roll_dice
        puts "Du rullede #{dice}"

        if dice > 1 && dice < 7
          temp_sum += dice
          puts "Midlertidige sum: #{temp_sum}"
        else
          puts 'Midlertidige sum nulstillet'
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

  def win_state
  end

  def roll_dice
    1 + rand(6)
  end

  private :roll_dice

  def want_to_move?(input)
    valid_pos = %w(yes y ja) # all the "yes" values
    valid_pos.include? input
  end
end

# Much the same methods as Player class but different implementations
class AI
  attr_accessor :bank, :name, :iq

  def initialize(name, iq = nil)
    @bank = 0
    @name = name
    @iq = iq || [:low, :high].sample # randomly select intelligence if nil
  end

  def player_turn
    temp_sum = 0
    dice = 0
    avg_dice = 0
    turn_number = 1
    loop do
      if want_to_move?(temp_sum)
        dice = roll_dice
        puts "Computeren \"#{@name}\" rullede #{dice}"

        if dice > 1 && dice < 7
          temp_sum += dice
          avg_dice = (avg_dice + dice) / turn_number
          turn_number += 1
          puts "Midlertidige sum: #{temp_sum}"
        else
          puts 'Midlertidige sum nulstillet'
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
    1 + rand(6)
  end

  private :roll_dice

  def want_to_move?(temp_sum)
    if iq == :high then should_stop = case temp_sum # the chance of stopping
                                      when (0..5) then 6
                                      when (5..10) then 4
                                      when (10..20) then 3
                                      else 2
                                      end
    elsif iq == :low
      should_stop = 3
    end
    rand(should_stop).nonzero?
  end

  protected :want_to_move?
end

# Startup Menu
# All options are represented as subclasses
class Menu
  # All options are derived from this class
  class Option
    attr_accessor :namepair, :on_select

    def initialize(namepair, on_select)
      @namepair = namepair
      @on_select = on_select
    end

    def ask(prompt)
      print prompt
      gets.chomp.strip
    end
nnnn
    def select
      on_select.call
    end
  end

  # AI vs AI option
  class AIVAI < Option
    def initialize
      super({ aivai: 'AI vs AI' },
            lambda do
              return AI.new('HAL'), AI.new('Marvin')
            end)
    end
  end

  # Player vs Player option
  class PVP < Option
    def initialize
      super({ pvp: 'Player vs Player' },
            lambda do
              return Player.new(ask('Player 1 name? ')),
              Player.new(ask('Player 2 name? '))
            end)
    end
  end

  # Player vs AI option
  class PVAI < Option
    def initialize
      super({ pvai: 'Player vs AI' },
            lambda do
              return AI.new('HAL'), Player.new(ask('Player name? '))
            end)
    end
  end

  # Exit option
  class EXIT < Option
    def initialize
      super({ exit: 'Exit' },
            -> { Kernel.exit(0) })
    end
  end

  attr_accessor :options

  def initialize
    @options = [AIVAI.new, PVP.new, PVAI.new]
  end

  def show_options
    @options.each do |op|
      pair = op.namepair.first
      puts "#{pair[0]}: #{pair[1]}"
    end
  end

  def create_option(str)
    str.downcase.gsub(/[^a-z0-9\s]/i, '').gsub(/\s+/, '_').to_sym
  end

  def handle_selection(sym)
    # find all options with that name (should only ever return 1 option)
    choice = @options.find { |op| op.namepair.key? sym } || :not_found
    choice.select
  end

  def start_menu
    loop do
      show_options
      input = create_option gets.chomp
      selection = handle_selection(input)
      selection if selection != :not_found
    end
  end
end

# Holds the players and a start up menu
# This is where the actual game takes place
class Board
  attr_accessor :cur_player, :players, :menu

  def initialize(menu)
    @menu = menu
    @players = @menu.start_menu
    @cur_player = @players[rand(players.length)]
  end

  def show_cur_player
    puts @cur_player.name
  end

  def switch_player
    temp = @players.pop # remove the current player
    @players.unshift temp # prepend player to list
    @cur_player = @players[0]
  end

  def play
    loop do
      show_cur_player
      @cur_player.player_turn
      if @cur_player.bank >= 100
        @current.win_state
      else
        switch_player
      end
    end
  end
end

def main
  menu = Menu.new
  board = Board.new(players, menu)
  board.play
end
