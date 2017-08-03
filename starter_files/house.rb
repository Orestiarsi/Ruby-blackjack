require_relative 'card'
class house
 def initialize(name)
  @hand = []
 end

 def give_hand(card)
  @hand.push(card)
 end

 def clear_hand
  @hand = []
 end

 def count_hand
  total = 0
  @hand.each {|card| total += card.value if card.rank != :A}
  ace_ct = @hand.count {|card| card.rank == :A}
  if total + ace_ct >= 21 then return total + ace_ct end
   @hand.each do |card|
   if card.rank == :A
    if total + 11 <= 21
    total += 11
    else total += 1 end
   end
  end
  total
 end

 def take_a_hit?
  if(!@turn_over)
   return count_hand < 17
  end
 end

 def print_top
  card = @hand[0]
  puts "house top card:"
 end

 def print_hand
  puts "house's Hand:"
  @hand.each{|card|
  puts "Total value: #{count_hand}"
 end
end
