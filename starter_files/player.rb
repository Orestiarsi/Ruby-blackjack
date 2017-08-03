class Player
 attr_accessor :name, :hand, :cash, :bet

 def initialize(name, hand, cash, bet)
  @name = name
  @hand = []
  @cash = cash
  @bet = bet
 end

 def give_hand(card)
  @hand.push(card)
 end

 def clear_hand
  @hand = []
 end

 def show_hand
  # printf("\n\t\tYour Hand: #{@hand.each}\n")
  puts "Current Hand:" @hand.each{|card|
  puts "Total value: #{count_hand}"
  puts "Current Bet: $#{bet} | Cash: $#{@cash}\n"
 end

 def make_bet
  puts "Enter an amount to bet above $#{@min_bet}:"
   ubet = 0
    while user_input = STDIN.gets.chomp
     uinput = Integer(user_input) rescue nil
     if uinput.nil?
      puts "Only plain integers are accepted as numbers."
      puts "Enter a number below #{@cash} and at least #{@min_bet}"
      next
     elsif @cash - uinput < 0
      puts "You don't have enough cash to make that bet."
      puts "Enter a number below #{@cash} and at least #{@min_bet}"
      next
     elsif uinput < @min_bet
      puts "The minimum bet is $#{@min_bet}."
      puts "Enter a number below #{@cash} and at least #{@min_bet}"
     else
      ubet = uinput
      break
    end
   end

    @bet = ubet
  end

  def count_hand
   total = 0
   @hand.each {|card| total += card.value
   if card.rank != :A}
   ace_ct = @hand.count {|card| card.rank == :A}
   if total + ace_ct >= 21 then return total + ace_ct end
    @hand.each do |card|
     if card.rank == :A
      if total + 11 <= 21
       total += 11
      else total += 1
      end
     end
    end
      total
 end

  def display_out
      puts "#{@name} busted, final hand count: #{count_hand}"
  end

  def take_a_hit?
   print_hand
   puts "Take a hit or stay? (hit/stay):"
   while user_input = STDIN.gets.chomp
   case user_input
    when "hit", "h"
    return true
     when "stay", "s"
     return false
   else
    puts "Invalid input. Enter hit/h to hit, or stay/s to stay"
     end
    end
  end
end
