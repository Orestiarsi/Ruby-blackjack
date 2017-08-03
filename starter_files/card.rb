class Card

    RANKS = [:A, 2, 3, 4, 5, 6, 7, 8, 9, 10, :J, :Q, :K]
    SUITS = [:spades, :hearts, :diomonds, :clubs]

  def value(rank)
    case rank
   when 2..10
    return rank
   when :A
    return 1
   when :J, :Q, :K
    return 10
   end
  end

  def initialize(rank, suit)
   @rank = rank
   @suit = suit
   @value = value
  end

  attr_accessor :rank, :suit, :value

  def >(a)
   self.rank < a.rank
  end

  def <(a)
   self.rank < a.rank
  end

  def ==(a)
   self.rank == a.rank && self.suit == a.suit
  end
end
