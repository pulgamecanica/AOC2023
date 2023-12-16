input = File.readlines('data.txt', chomp: true)
test_input = <<-EOT
TTTTT 10
KKKKK 20
QQQQ1 9
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
EOT
# input = test_input.split("\n")

RULE_CARDS = "AKQJT98765432"
def get_rank(card)
  return 0 if card.nil?
  RULE_CARDS.size - RULE_CARDS.index(card)
end

class Hand
  attr_reader :cards, :bid, :pairs, :highest_pair

  def initialize(cards, bid)
    @cards, @bid = cards, bid
    @pairs = {}
    @cards.each { |card| pairs[card] = (pairs[card] || 0) + 1 }
    # pairs.select! { |card, repetitions| repetitions > 1 }
    @highest_pair = highest_pair
  end

  def num_pairs
    return 5 - pairs.size
  end

  def get_highest_card_rank
    highest = 0
    @cards.each do |card|
      if (get_rank(card) > highest)
        highest = get_rank(card)
      end
    end
    highest
  end

  def highest_pair
    highest = {card: nil, repetitions: 0}
    pairs.each do |card, repetitions|
      if highest.nil?
        highest = {card: card, repetitions: repetitions}
      else
        if (repetitions >= highest[:repetitions] && get_rank(card) > get_rank(highest[:card]))
          highest = {card: card, repetitions: repetitions}
        end
      end
    end
    highest
  end

  def to_s
    "Cards: #{cards} $#{bid}, Founded: #{pairs}"
  end

  def <=>(hand)
    if (@highest_pair[:repetitions] > 3 || hand.highest_pair[:repetitions] > 3) # When highest card, has more than 3 repeated
      return compare_by_same_kind_repetition(hand)
    else # Compare by pair (fullhouse beats everything three of a kind beat any pair)
      return compare_by_pair(hand)
    end
  end

  def is_fullhouse
    return @highest_pair[:repetitions] == 3 && num_pairs == 2
  end

  private

    def compare_by_high_card(hand)
      @cards.zip(hand.cards) do |c1, c2|
        if (get_rank(c1) != get_rank(c2))
          return get_rank(c1) - get_rank(c2)
        end
      end
      return 1
    end

    def compare_by_same_kind_repetition(hand)
      if (@highest_pair[:repetitions] != hand.highest_pair[:repetitions])
        return @highest_pair[:repetitions] - hand.highest_pair[:repetitions]
      end
      return compare_by_high_card(hand)
    end

    def compare_by_pair(hand)
      if (is_fullhouse || hand.is_fullhouse) # When there is a fullhouse in either hand
        if (is_fullhouse && hand.is_fullhouse) # When both are fullhouse 
          return compare_by_high_card(hand)
        else # fullhouse beats anything
          return is_fullhouse ? 1 : -1
        end
      elsif (@highest_pair[:repetitions] == 3 && hand.highest_pair[:repetitions] == 3) # Case when both are three of a kind
        return compare_by_high_card(hand)
      elsif (@highest_pair[:repetitions] == 3 || hand.highest_pair[:repetitions] == 3) # Case when there is at least three of a kind in any hand
        return @highest_pair[:repetitions] - hand.highest_pair[:repetitions]
      elsif (num_pairs == 0 && hand.num_pairs == 0)
        if (get_highest_card_rank == hand.get_highest_card_rank)
          return compare_by_high_card(hand)
        else
          return get_highest_card_rank - hand.get_highest_card_rank
        end
      elsif (num_pairs != hand.num_pairs) # Case when there is a hand with more pairs
        return num_pairs - hand.num_pairs
       end # When the amount of pairs is the same and rank is the same
      return compare_by_high_card(hand)
    end

    def compare_by_fullhouse(hand)
      if (is_fullhouse && hand.is_fullhouse) # When both are fullhouse 
        return compare_by_high_card(hand)
      elsif (num_pairs != hand.num_pairs) # When at least one had has fullhouse
        return num_pairs - hand.num_pairs
      elsif (isFullHouse)
        return 1
      else
        return -1
      end
    end
end


hands = []
input.each do |line|
  l = line.split(" ")
  cards = l[0]
  bid = l[1].to_i
  h = Hand.new(cards.split(""), bid)
  hands.push(h)
  puts "#{cards} => % -18s -> highest: #{h.highest_pair}" % [h.pairs]
end

hands.sort!{ |a, b| a <=> b }

puts "Ordered:"
hands.each {|h| puts h}

res = 0
hands.each_with_index do |hand, i|
  puts "BID: #{hand.bid} * #{i + 1}"
  res += hand.bid * (i + 1)
end
# res = hands.sum {|h| h.bid * }
puts "Result: #{res}"
