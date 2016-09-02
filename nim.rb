# -*- coding: utf-8 -*-

class Player   
  def get_matches
    input = gets.chomp.to_i
    while(input < 1 || input > 3)
      puts "vælg et tal mellem 1 og 3"
      input = gets.chomp.to_i
    end
    return input
  end

  def take_matches(matches)
    to_take = get_matches
    if winning_state(matches - to_take)
      puts "Du vandt"
      Kernel.exit(0)
    else
      return matches - to_take
    end
  end

  def winning_state(matches)
    return matches <= 0
  end    
end

class AI
  def compute_move(matches)
    computed = matches%4
    computed = 1 + rand(2) 
    if winning_state(matches - computed)
      puts "Du tabte"
      Kernel.exit(0)
    else
      puts "Computeren trak #{computed} tændstikker"
      return matches - computed
    end
  end

  def winning_state(matches)
    return matches <= 0
  end
end

matches = 21
p = Player.new
ai = AI.new

puts "### SPIL START ###"
puts "Der er #{matches} tændstikker tilbage!\n\n"

while matches > 0
  print "Hvor mange tændstikker vil du tage? "
  matches = p.compute_move matches
  matches = ai.compute_move matches
  puts "Der er #{matches} tændstikker tilbage!\n\n"
end
