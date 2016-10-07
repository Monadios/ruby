# -*- coding: utf-8 -*-

class Player
  attr_accessor :hand, :num_cards, :name
  attr_reader :asked

  def initialize(name, hand, game_cards)
    @name = name
    @hand = hand
    @game_cards = game_cards
    @asked = {}
  end

  def turn
    puts 'Vil du spørge eller gætte?'
    input = user_input_type(String)

    until (choice = ask_or_guess input) != :not_found
      puts "Svaret skal være enten 'G', 'S' eller 'Q'"
      input = gets.chomp.strip
    end

    card = user_input_type(Fixnum) unless choice == :quit

    { choice => card }
  end

  def ask_or_guess(input)
    case input.downcase
    when 'g'
      :guess
    when 's'
      :ask
    when 'q'
      :quit
    else
      :not_found
    end
  end

  #This is for getting user input of a certain type
  def user_input_type(type)
    begin
      fns = {
             Fixnum => ->(x) { Integer(x) },
             String => ->(x) { String(x)  },
             Symbol => ->(x) { x.split.join("_").intern}
            }

      fn = fns[type]

      fn.call(gets.chomp.strip)

    rescue
      puts "Input skal være af typen #{type}"
      retry
    end
  end

 
end


class Board
  attr_accessor :p1, :p2, :cards, :facedown

  attr_reader :cur_player

  def initialize
    @cards = (1..11).to_a # TODO: fix magic numbers
    hand1, hand2, @facedown = @cards.shuffle.each_slice(11 / 2).to_a
    @facedown = @facedown[0]
    @p1 = Player.new('A', hand1, 11)
    @p2 = Player.new('Computer', hand2, 11)
    @cur_player = (rand(2).zero? ? @p1 : @p2)
  end

  def switch_player
    @cur_player = (@cur_player == p1 ? p2 : p1)
  end

  def play
    loop do
      output_state @cur_player
      p_round = @cur_player.turn
      type = p_round.keys.first
      value = p_round.values.first
      if type == :guess
        if value == @facedown
          winner(@cur_player)
          quit
        else
          loser(@cur_player)
          quit
        end
      end
    end
  end

  def winner(player)
    puts "#{player.name.capitalize} vandt!"
  end

  def loser(player)
    puts "#{player.name.capitalize} tabte!"
  end

  def output_state(player)
    puts "Dine kort: #{player.hand}"
  end

  def quit
    puts "Spillet lukkes ned nu"
    Kernel.exit(0)
  end

  private :switch_player, :winner, :output_state, :quit
end

def main
  # Dine kort
  # Resten af kort
end
