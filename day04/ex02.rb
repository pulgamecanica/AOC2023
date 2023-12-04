input = File.readlines('data.txt', chomp: true)

class Card
  attr_reader :winners, :numbers, :matches
  attr_accessor :copies

  def initialize(winners, numbers)
    @winners, @numbers = winners, numbers
    @matches = get_matches
    @copies = 1
  end

  private
    def get_matches
      @numbers.size - (@numbers - @winners).size
    end
end

cards = {}
input.each_with_index do |line, i|
  lists = line.split(": ")[1].split(" | ")
  cards[i] = Card.new(lists[0].split(" "), lists[1].split(" "))
end

cards.each do |i, card|
  card.copies.times do
    card.matches.times do |n|
      cards[i + n + 1].copies += 1
    end
  end
end

res = cards.sum {|i, c| c.copies}
puts "Result: #{res}"