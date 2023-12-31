file_path = File.expand_path("./../data.txt", __FILE__)
input     = File.read(file_path)
file_data = input.split("\n")

def getColorsRBG(colors)
  return [(colors.find {|c| c.include?("red")}).to_i,
    (colors.find {|c| c.include?("green")}).to_i,
    (colors.find {|c| c.include?("blue")}).to_i]
end

class Bag
  attr_reader :red, :blue, :green

  def initialize(colors)
    colors = getColorsRBG(colors)
    @red = colors[0].to_i
    @green = colors[1].to_i
    @blue = colors[2].to_i
  end
end

class Game
  attr_reader :id, :bags

  def initialize(id)
    @id = id
    @bags = []
  end

  def addBag(bag)
    @bags.push(bag)
  end

  def getMinimumSetPower
    return getMinimumSet.inject(:*)
  end

  private
    def getMinimumSet
      return [bags.max { |bag1, bag2| bag1.red<=>bag2.red }.red,
        bags.max { |bag1, bag2| bag1.green<=>bag2.green }.green,
        bags.max { |bag1, bag2| bag1.blue<=>bag2.blue }.blue]
    end
end

def readData(file_data)
  games = []

  file_data.each do |line|
    game = Game.new(line.split(":")[0].tr('^0-9', '').to_i)
    shows = line.split(":")[1].split(";")
    shows.each do |show|
      game.addBag(Bag.new(show.split(",")))
    end
    games.push(game)
  end
  return games
end

# Answer: 72970
games = readData(file_data)
puts "Result: #{games.sum {|game| game.getMinimumSetPower()}}"
