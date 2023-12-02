file_path = File.expand_path("./../data.txt", __FILE__)
input     = File.read(file_path)
file_data = input.split("\n")

def getColorsRBG(colors)
  red, green, blue = 0, 0, 0

  colors.each do |color|
    if (color.include?("red"))
      red += color.to_i
    elsif (color.include?("blue"))
      blue += color.to_i
    elsif (color.include?("green"))
      green += color.to_i
    end
  end
  return [red, green, blue]
end

class Bag
  attr_reader :red, :blue, :green
  
  def initialize(colors)
    colors = getColorsRBG(colors)
    @red = colors[0].to_i
    @green = colors[1].to_i
    @blue = colors[2].to_i
  end

  def isBagPossible(red, green, blue)
    return @red <= red && @blue <= blue && @green <= green 
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

  def isGamePossible(red, green, blue)
    (@bags.filter { |bag| bag.isBagPossible(red, green, blue)}).size == @bags.size
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
# Conditions: only 12 red cubes, 13 green cubes, and 14 blue cubes | Answer: 3099
games = readData(file_data)
games.filter!{ |game| game.isGamePossible(12, 13, 14) }
puts "Result: #{games.sum { |game| game.id }}"
