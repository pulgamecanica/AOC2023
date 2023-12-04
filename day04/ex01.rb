input = File.readlines('data.txt', chomp: true)

class Card
  attr_reader :winners, :numbers

  def initialize(winners, numbers)
    @winners, @numbers = winners, numbers
  end

  def get_value
    matches = @numbers.size - (@numbers - @winners).size
    return 0 if matches == 0  
    return 2**(matches - 1)
  end
end

cards = []
input.each do |line|
  lists = line.split(": ")[1].split(" | ")
  cards.push(Card.new(lists[0].split(" "), lists[1].split(" ")))
end
res = cards.sum {|c| c.get_value}
puts "Result: #{res}"
