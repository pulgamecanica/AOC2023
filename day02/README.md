# AOC Day 02

### Part 1

The problem presented is a Game, the game is about colors
There are 3 possible colors in the game: **red** | **green** | **blue**
Each turn, you are presented with a set of colors and the quantity
Every time you play you are presented with one or more sets
  
    For example (One turn may look like this):
    >4 blue, 2 green
    >1 red, 2 green
    >5 blue, 3 red, 1 green

In the data input, each Game is represented in each line


```
  Game 1: 4 red, 8 green; 8 green, 6 red; 13 red, 8 green; 2 blue, 4 red, 4 green

  >4 red, 8 green
  >8 green, 6 red
  >13 red, 8 green
  >2 blue, 4 red, 4 green
```

For part one, your job is to find out which games are possible, given a maximum number for each color
The game which are not possible, are the games where there are more colors than the given

    For example, if you are given the condition: (5 red, 7 blue, 2 green)

    Possible Game:

    >4 red, 1 green
    >5 green, 2 blue

    Impossible Game:

    >6 red, 1 green
    >5 green, 2 blue

    There are 6 reds, and the condition indicates 5 reds at most

The solution of the problem should be the addition of all the game ID's which are possible!

### Solution Part 1️⃣

To solve this problem, implement an object oriented design to simulate the games, and filter the games which are not possible. Now you only are left to add all the posssible games IDs!

We start by creating an Object to represent our game. It will have an id and a list which will contain our sets of colors for this game.

```rb
class Game
  attr_reader :id, :bags

  def initialize(id)
    @id = id
    @bags = []
  end
end
```

Also, create an object to represent a set of colors (this will be the contents of our bags list)

```rb
class Bag
  attr_reader :red, :green, :blue

  def initialize(red, green, blue)
    @red = red
    @green = green
    @blue = blue
  end
end

```

All there is left to do is to parse the file, and create a function which analizes if a game is possible

#### File Parsing
One line might look something like this:

```rb
  "Game 1: 4 red, 8 green; 8 green, 6 red; 13 red, 8 green; 2 blue, 4 red, 4 green"
```

Lets separate our line, firstly in two parts, the `Game` and the `Sets` 
Notice how this is separated by a `colon`, we can use `split(":")`

```rb
  line.split(":")
    => ["Game 1"] [" 4 red, 8 green; 8 green, 6 red; 13 red, 8 green; 2 blue, 4 red, 4 green"]
```

With the first element of the array, you can already create a game, just take the id, and create a game
(Using the same strategy from Day01, remove all characters which are not numbers, and the id will be what's left)
```rb
  line.split(":")[0]
    => "Game 1"
  line.split(":")[0].tr('^0-9', '').to_i
    => 1
  Game.new(line.split(":")[0].tr('^0-9', '').to_i)
    => Game Object (id: 1, bags: [])

```

Now let's focus on the second part, separate all the sets, in order to parse each set.
Notice how each set is separated by a `semi-colon`, we can use `split(";")`

```rb
  line.split(":")[1]
    => " 4 red, 8 green; 8 green, 6 red; 13 red, 8 green; 2 blue, 4 red, 4 green"
  line.split(":")[1].split(";")
    => [" 4 red, 8 green", " 8 green, 6 red", " 13 red, 8 green", " 2 blue, 4 red, 4 green"]
```

For each set, we must parse each color presented, the colors are separated by a `coma`, again, `split(",")`

```rb
  sets = line.split(":")[1].split(";")
    => [" 4 red, 8 green", " 8 green, 6 red", " 13 red, 8 green", " 2 blue, 4 red, 4 green"]
  sets.each do |set|
    set.split(",")
    => [" 4 red", " 8 green"]
    => [" 8 green", "6 red"]
    => [" 13 red", " 8 green"]
    => [" 2 blue", " 4 red", " 4 green"]
  end
```

Perfect, now we can create our Bags with our colors, and push them to our bags list, there is just one small issue.
The colors are not always in the same order, for this we can create a function which returns the amout of each color, presented with a set.

```rb
  def getRGB(unordered_set_of_colors)
    red, green, blue = 0, 0, 0

    unordered_set_of_colors.each do |color|
      if (color.include?("red"))
        red += color.tr('^0-9', '').to_i
      elsif (color.include?("blue"))
        blue += color.tr('^0-9', '').to_i
      elsif (color.include?("green"))
        green += color.tr('^0-9', '').to_i
      end
    end

    return [red, green, blue]
  end
```

The code is quite readable, you iterate the unordered set of colors and for each element, you will find which color it is. For each color, set the right variable. At the end, return an ordered array of Red Green & Blue

Finally, to put everything togeather:

```rb
# Add a function in your Game object to add bags
class Game
  ...
  def addBag(bag)
    @bags.push(bag)
  end
end

def parseData(file_data)
  games = []
  file_data.each do |line|
    game = Game.new(line.split(":")[0].tr('^0-9', '').to_i)
    sets = line.split(":")[1].split(";")
    sets.each do |set|
      rgb = getRGB(set.split(","))
      game.addBag(Bag.new(rbg[0], rbg[1], rbg[2]))
    end
    games.push(game)
  end
  return games
end
```

#### Condition (Possible games filter)

To know if a game is possible, we need to check all the game bags, and verify that none of the bags have more than the amount presented in the condition.

We should implement a function on our Bag class, to see if a bag is possible, given the conditions.
The bag is possible, when the color amount is less or equals.
And then verify this function for all the game bags.


```rb
class Bag
  ...
  def isBagPossible(max_red, max_green, max_blue)
    return  @red <= max_red && @green <= max_green && @blue <= max_blue
  end
end

class Game
  ...
  def isGamePossible(red, green, blue)
    @bags.each do |bag|
      return false if not bag.isBagPossible(red, green, blue)
    end
    return true
  end
end
```

Now you can use this function to filter all you games and add all the game IDs which are possible games.

For example:

```rb
  max_red, max_green, max_blue = 11, 12, 13

  games.filter! { |game| game.isGamePossible(max_red, max_green, max_blue)}

  solution = games.sum { |game| game.id }
```

> Note `filter!` modifies the array, so we can rest assured that the array will remove all games which evaluated `isGamePossible` to false


#### More Advanced (maybe less readable)

The function `isGamePossible` can also be done with a one liner ;)
You can filter the list using the function `isBagPossible`, the game is possible if the array gets no filters.

```rb
class Game
  ...
  def isGamePossible(red, green, blue)
    (@bags.filter { |bag| bag.isBagPossible(red, green, blue) }).size != @bags.size
  end
end
```

> Note: I used the size to compare for performance, you can also prefer to compare the arrays (without size)

***

### Part 2

In this section you need to find, for each game, which is the set of colors minimum to make a game possible

Remember, one game is a collection of color sets (bags)
You must find out what is the minimum amount of colors which would make this game possible.

Then we need to multiply the numbers for each color, this is denominated as the power of a set.

We need to find the minimum set of colors which make the game possible, and find the power of the set.

The solution should be the addition of all the powers of the minimum sets in all games.

### Solution Part 2️⃣

Each game has a collection of color sets (bags)

We need to analize all bags, and save the highest colors (RGB) founded
Once we finished registering the highest red of our bags, the highest blue, and green of our bags, we are almost finished. Because this is the minimum amount of colors which would make the game possible.

We can create a function which returns the minimum set of a game following this logic:

```rb
class Game
  ...
  
  def getMinimumSet
    red, green, blue = 0, 0, 0
    bags.each do |bag|
      if (bag.red > red)
        red = bag.red
      end
      if (bag.green > green)
        green = bag.green
      end
      if (bag.blue > blue)
        blue = bag.blue
      end
    end
    return [red, green, blue]
  end

end
```

Now we can also create a function which returns the power of the minium set of a game:

```rb
class Game
  ...

  def getMinimumSetPower
    minimumSet = getMinimumSet
    return minimumSet[0] * minimumSet[1] * minimumSet[2]
  end

end

```

Now all there is to do, is to sum all the minimum set powers of each game:

```rb
  games.sum { |game| game.getMinimumSetPower() }

```

#### More Advanced (maybe less readable)

The function `getMinimumSet` can also be done with a one liner ;)
Using the function max, to filter onlly the bag with the max red, the bag with the max blue & the bag with the max green

```rb
class Game
  ...
  def getMinimumSet
    return [bags.max { |bag1, bag2| bag1.red<=>bag2.red }.red,
      bags.max { |bag1, bag2| bag1.green<=>bag2.green }.green,
      bags.max { |bag1, bag2| bag1.blue<=>bag2.blue }.blue]
  end
end
```

The function getMinimumSetPower can also be reduced with a one liner ;)
Simply use inject to inject the product 

```rb
class Game
  ...
  def getMinimumSet
    return [bags.max { |bag1, bag2| bag1.red<=>bag2.red }.red,
      bags.max { |bag1, bag2| bag1.green<=>bag2.green }.green,
      bags.max { |bag1, bag2| bag1.blue<=>bag2.blue }.blue]
  end
end
```

```rb
class Game
  ...
  def getMinimumSetPower
    return getMinimumSet.inject(:*)
  end
end
```

GL!
Have fun coding!