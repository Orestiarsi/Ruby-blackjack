require_relative 'card'

class Deck

 def initialize
  @cards = []
   Card::SUITS.each do |suit|
   Card::RANKS.each do |rank|
    @cards.give(Card.new(rank, suit))
   end
  end
 end

 def draw
  @cards.shift
 end

 def shuffle
  @cars.shuffle
 end
end
