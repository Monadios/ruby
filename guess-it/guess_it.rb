# -*- coding: utf-8 -*-
class Decision
  attr_reader :actions, :accept_vals, :key, :val
  attr_accessor :choice

  def initialize()
    @actions = {'g' => :guess,
                's' => :ask,
                'q' => :quit
               }

    @accept_vals = @actions.keys.join(",").upcase
  end

  def make_decision(input)
    @actions.fetch(input) do
      invalid_choice
      :not_found
    end
  end

  def invalid_choice
    puts "Svaret skal være en af de følgende: #{@accept_vals}"
  end
end

class Player
  attr_accessor :hand, :num_cards, :asked
  attr_reader :decision

  def initialize(hand, game_cards)
    @hand = hand
    @game_cards = game_cards
    @asked = {}
    @decision = Decision.new
  end

  def turn(state)
    puts "Dine kort #{@hand.join(',')}"
    puts 'Vil du spørge eller gætte?'
    input = String(gets.chomp.strip)

    until (choice = @decision.make_decision input) != :not_found
      @decision.invalid_choice
      input = gets.chomp.strip
    end

    card = Integer(gets.chomp.strip) unless choice == :quit

    @decision.choice = { choice => card }
    return @decision
  end

  def has_card? card
    hand.include? card
  end
end

class AI
  attr_accessor :asked, :hand, :num_cards

  def initialize(hand, game_cards)
    @hand = hand
    @game_cards = game_cards
    @asked = {}
  end

  def turn(state)
    return { choice => card }
  end

  def has_card? card
    hand.include? card
  end
end

class Board
  attr_accessor :p1, :p2, :cards, :downcard
  attr_reader :cur_player, :num_cards

  def initialize(num_cards=11)
    num_cards+=1 unless (num_cards-1).even?

    @num_cards = num_cards
    @cards = (1..@num_cards).to_a # TODO: fix magic numbers
    hand1, hand2, @downcard = @cards.shuffle.each_slice(@num_cards / 2).to_a
    @downcard = @downcard[0]
    @p1 = Player.new(hand1, num_cards)
    @p2 = AI.new(hand2, 11)
    @cur_player,@other_player = [@p1,@p2].shuffle
  end

  def switch_player
    @cur_player,@other_player = @other_player,@cur_player
  end

  def play
    loop do
      resp = @cur_player
      case resp
       when :ask
        @cur_player.asked[key] = @other_player.has_card? val
        puts @cur_player.asked
      when :quit
        quit
      when :guess
      end
    end
  end

  def winner(player)
    puts "#{player.name.capitalize} vandt!"
    quit
  end

  def loser(player)
    puts "#{player.name.capitalize} tabte!"
    quit
  end

  def output_state(player)
    puts "Dine kort: #{player.hand}"
  end

  def quit
    puts 'Spillet lukkes ned nu'
    Kernel.exit(0)
  end

  private :switch_player, :winner, :output_state, :quit
end
