NUMBERCARDS = ["2","3","4","5","6","7","8","9","10"]
FACECARDS = ["J", "K", "Q", "A"]

class Card

	attr_reader :card_number
	def initialize(card_number)
		@card_number = card_number
	end

	def to_s
		@card_number
	end

	def value
		if @card_number == "A"
			return 1
		elsif FACECARDS.include? (@card_number)
			return 10
		else
			return @card_number.to_i
		end
	end
end

# ---------------------------------------------------

class Hand
	attr_accessor :current_value, :cards, :bust, :bet, :has_ace, :value_without_ace, :number_of_aces
	def initialize
		@current_value = 0
		@cards = Array.new
		@bust = false
		@bet = 0
		@has_ace = false
		@value_without_ace = 0
		@number_of_aces = 0
	end

	def hit(card_number, hidden = false)
		@cards.push(Card.new(card_number, hidden))
		if !@value_without_ace or !@current_value or !@number_of_aces
			@value_without_ace = 0
			@current_value = 0
			@number_of_aces = 0
		end
		if card_number == "A"
			@has_ace = true
			@number_of_aces += 1
		else
			if NUMBERCARDS.include? (card_number)
				@value_without_ace += card_number.to_i
			else
				@value_without_ace += 10
			end
		end
		@current_value = @value_without_ace
		if @has_ace
			i = 0
			while i < @number_of_aces
				if @current_value + 11 > 21
					@current_value += 1
				else
					@current_value += 11
				end
				i += 1
			end
		end
		if @current_value > 21
			@bust = true
		end
	end

	def get_cards(player_number, hand)
		printf("\n\n\t\t Player #{player_number}'s current cards for hand #{hand} are:  \n\n")
		@cards.each do |c|
			printf("\n\n\t\t #{c.card_number}  \n\n")
		end
  printf("\n\n\t\t With a value of #{@current_value}  \n\n")
	end

	def was_split(card_number)
		@current_value = 0
		@cards = Array.new
		@has_ace = false
		@value_without_ace = 0
		@number_of_aces = 0
		hit(card_number)
	end
end
# -------------------------------------------------------

class Player
	attr_reader :player_number, :money, :cards, :bet, :hands, :initial_bet
	def initialize(player_number)
		@player_number = player_number
		@money = 1000
		@cards = Array.new
		@bust = false
		@bet = 0
		@has_ace = false
		@value_without_ace = 0
		@number_of_aces = 0
		@hands = Array.new
		@hands.push(Hand.new)
		@initial_bet = 0
	end

	def hit(card_number, hand = 0, hidden = false)
		if !@hands[hand]
			@hands[hand] = Hand.new
		end
		@hands[hand].hit(card_number, hidden)
	end

	def first_hit(card1_number, card2_number)
		hit(card1_number)
		hit(card2_number)
	end

	def get_cards(hand = 0)
		if @hands.length > 1
			@hands[hand].get_cards(@player_number, hand)
		else
   printf("\n\n\t\t Player #{@player_number}'s current cards are:\n\n")
			@hands[0].cards.each do |c|
				printf("\n\n\t\t #{c} \n\n")
			end
			printf("\n\n\t\t With a value of #{@hands[0].current_value}  \n\n")
		end
	end

	def place_bet(bet, hand = 0)
		if (bet > @money || bet < 0.1)
			return false
		else
			if @initial_bet == 0
				@initial_bet = bet
			end
			@hands[hand].bet += bet
			@money -= bet
			return true
		end
	end

	def reset
		@cards = Array.new
		@bust = false
		@bet = 0.0
		@contains_ace = false
		@value_without_ace = 0
		@number_of_aces = 0
		@hands = Array.new
		@hands.push(Hand.new)
		@initial_bet = 0
	end

	def win(hand = 0)
		@money += @hands[hand].bet * 2
		if number_of_hands > 1
			printf("\n\n\t\t Player #{@player_number} won on hand #{hand}!  \n\n")
		else
			printf("\n\n\t\t Player #{@player_number} won!  \n\n")
		end
	end

	def lose(hand = 0)
		if number_of_hands > 1
			puts "Player #{@player_number} lost on hand #{hand}!"
		else
			puts "Player #{@player_number} lost!"
		end
	end

	def push(hand = 0)
		@money += @hands[hand].bet
		if number_of_hands > 1
			printf("\n\n\t\t Player #{@player_number} pushed on hand #{hand}!  \n\n")
		else
			printf("\n\n\t\t Player #{@player_number} pushed!  \n\n")
		end
	end

	def win_blackjack
		@money += @hands[0].bet*2.5
		printf("\n\n\t\t Player #{@player_number} won!  \n\n")
	end

	def is_broke?
		if @money < 0.1
			return true
		else
			return false
		end
	end

	def has_natural?
		if number_of_hands == 1 and @hands[0].current_value == 21 and cards_in_hand(0) == 2
			return true
		end
	end

	def has_21?(hand = 0)
		if @hands[hand].current_value == 21 and @hands[hand].cards.length > 2
			return true
		end
	end

	def number_of_hands
		return @hands.length
	end

	def current_value(hand)
		return @hands[hand].current_value
	end

	def bust(hand)
		return @hands[hand].bust
	end

	def cards_in_hand(hand)
		return @hands[hand].cards.length
	end

	def has_money
		printf("\n\n\t\t Player #{player_number}'s current money is now #{@money}  \n\n")
	end

end

# ---------------------------------------------------

class House < Player
	attr_reader :current_value, :bust
	def initialize()
		@player_number = 0
		@cards = Array.new
		@current_value
	end
	def hit(card_number, hidden = false, hand = 0)
		@cards.push(Card.new(card_number, hidden))
		if !@value_without_ace or !@current_value or !@number_of_aces
			@value_without_ace = 0
			@current_value = 0
			@number_of_aces = 0
		end
		if card_number == "A"
			@has_ace = true
			@number_of_aces += 1
		else
			if NUMBERCARDS.include? (card_number)
				@value_without_ace += card_number.to_i
			else
				@value_without_ace += 10
			end
		end
		@current_value = @value_without_ace
		if @has_ace
			i = 0
			while i < @number_of_aces
				if @current_value + 11 > 21
					@current_value += 1
				else
					@current_value += 11
				end
				i += 1
			end
		end
		if @current_value > 21
			@bust = true
		end
	end
	def first_hit(card1_number, card2_number)
		hit(card1_number, true)
		hit(card2_number)
	end
	def get_cards
		printf("\n\n\t\t House's current cards are:   \n\n")
		@cards.each do |c|
			printf("\n\n\t\t #{c} \n\n")
		end
		printf("\n\n\t\t With a value of #{@current_value}  \n\n")
	end
	def unhide_card
		@cards.each do |c|
			if c.hidden
				c.unhide
				return
			end
		end
	end
	def has_natural?
		if @cards.length == 2 and @current_value == 21
			return true
		else
			return false
		end
	end
end

# -----------------------------------------------------
class Game

	def initialize

		@numplayers = 0
		get_num_players
		@players = Array.new
		(1..@numplayers).each do |i|
			@player = Player.new(i)
			@players.push(@player)
		end
		@house = House.new

		@deck = Array.new
		add_cards

		while !(@players.empty?)
			get_all_bets
			first_round
			player_cards
			house_cards
			all_player_turns
			house_turn
			evaluate_game
			play_or_quit
		end
		printf("\n\n\t\t Game over!  \n\n")
	end
	def get_num_players
		players_valid = false
		while !players_valid do
			printf("\n\n\t\t Input the number of players  \n\n")
			@numplayers = gets.to_i
			if @numplayers <= 0
				printf("\n\n\t\t Error! Please enter a number of players higher than 0  \n\n")
			else
				players_valid = true
				return
			end
		end
	end

	def add_cards
		(4*(@numplayers)).times do
			@deck += NUMBERCARDS
			@deck += FACECARDS
		end
		@deck.shuffle!
	end

	def get_all_bets
		@players.each do |p|
			bet(p)
		end
	end

	def bet(player, hand = 0)
		while true
			printf("\n\n\t\t Player #{player.player_number}, your current money is #{player.money}. Please enter a bet  \n\n")
			bet = gets.to_f
			if (player.place_bet(bet, hand))
				printf("\n\n\t\t You bet #{player.hands[hand].bet}. Your current money is #{player.money}.  \n\n")
				break
			end
			printf("\n\n\t\t Enter a valid bet.  \n\n")
		end
	end

	def first_round
		@house.first_hit(@deck.pop, @deck.pop)
		@players.each do |p|
			p.first_hit(@deck.pop, @deck.pop)
		end
	end

	def player_cards(hand = 0)
		@players.each do |p|
			p.get_cards(hand)
		end
	end

	def house_cards
		printf("\n\n\t\t House has:  \n\n")
		@house.cards.each do |c|
			printf("\n\n\t\t #{c}  \n\n")
		end
		printf("\n\n\t\t   \n\n")
	end

	def all_player_turns
		@players.each do |p|
			player_turn(p)
		end
	end

	def player_turn (player, hand = 0)
		if (hand >= player.number_of_hands)
			return
		end
		printf("\n\n\t\t Player #{player.player_number}'s turn  \n\n")
		player.get_cards(hand)
		if player.has_natural?
			printf("\n\n\t\t Contratulations! you rubied  \n\n")
			return
		end
		while true
			printf("\n\n\t\t Enter hit to hit or stay to stay  \n\n")
			move = gets.chomp
			if move == "hit"
				if hit(player, hand)
					break
				end
				if split(player, hand)
					return
				end
				if double_down(player, hand)
					return
				end
			elsif move == "stay"
				printf("\n\n\t\t You stayed at score #{player.current_value(hand)}  \n\n")
				break
			end
		end
		player_turn(player, hand + 1)
	end

	def hit(player, hand)
		card = @deck.pop
		printf("\n\n\t\t You got #{card}!  \n\n")
		player.hit(card, hand)
		printf("\n\n\t\t Your new score is #{player.current_value(hand)}  \n\n")
		if player.has_21?(hand)
			return true
		end
		if @deck.size < 21
			add_cards
		end
		if player.bust(hand)
			printf("\n\n\t\t Bust!  \n\n")
			return true
		end
		return false
	end

	def house_turn
		@house.unhide_card
		@house.get_cards
		if @house.has_natural?
			printf("\n\n\t\t House has blackjack!  \n\n")
			return
		end
		while @house.current_value < 17
			card = @deck.pop
			printf("\n\n\t\t House hit and got #{card}!  \n\n")
			@house.hit(card)
			@house.get_cards
			if @house.bust
				printf("\n\n\t\t Bust!  \n\n")
			end
		end
	end

	def evaluate_game
		broke_players = Array.new
		if @house.bust
			@players.each do |p|
				for hand in 0..p.number_of_hands - 1
					if p.has_natural?
						p.win_blackjack
					elsif !p.bust(hand)
						p.win(hand)
					else
						p.lose(hand)
					end
					if p.is_broke?
						broke_players.push(p)
					end
				end
			end
		else
			@players.each do |p|
				for hand in 0..p.number_of_hands - 1
					if p.bust(hand)
						p.lose(hand)
					elsif p.has_natural?
						if @house.has_natural?
							p.push(hand)
						else
							p.win_blackjack
						end
					elsif p.current_value(hand) > @house.current_value
						p.win(hand)
					else
						p.lose(hand)
					end
					if p.is_broke?
						broke_players.push(p)
					end
				end
			end
		end
		@house.reset
		@players -= broke_players
		@players.each do |p|
			p.has_money
		end
	end

	def play_or_quit
		quitters = Array.new
		@players.each do |p|
			printf("\n\n\t\t Player #{p.player_number}, type any key to keep playing or quit to quit  \n\n")
			option = gets.chomp
			if option == "quit"
				printf("\n\n\t\t GoodBye  \n\n")
				quitters.push(p)
			else
				p.reset
			end
		end
		@players -= quitters
	end

end

game = Game.new
