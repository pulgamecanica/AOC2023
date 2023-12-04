# AOC Day 03

### Part 1

You are presented with a scratch cards problem<br>
Given a list of winning numbers, and a list of the numbers you have, find how many winning numbers you have.<br>
The first match makes the card worth one point and each match after the first doubles the point value of that card.<br>
This can also be resolved with the following equation:<br>

```
  card total points = 2^(matches-1) 
```

Each line of your input defines a scratch card (winning numbers & your numbers)

### Solution Part 1️⃣

Define the Card object, it will have two lists, winning numbers and your numbers

```rb
class Card
  attr_reader :winners, :numbers

  def initialize(winners, numbers)
    @winners, @numbers = winners, numbers
  end
end
```

Now create a function which returns the points that correspond to the card:<br>
To get the amount of matches, you can exclude all the winning numbers from your numbers list, and calculate the difference between the original numbers.

```
winners: [1, 3, 4]
numbers: [1, 1, 1, 4, 2, 2, 42]

As you can see, the amount of matches is 4
The first ones and the single four

Removing the winners from the original numbers list, will produce a list with the number which are no match
after removing winners: [2, 2, 42]

To see how many winning numbers you have, just calculate the difference between this list of removed winning numbers and the original numbers list

[1, 1, 1, 4, 2, 2, 42].size - [2, 2, 42].size = 7 - 3 = 4
```

```rb
class Card
  ...

  def get_points
    matches = @numbers.size - (@numbers - @winners).size
    return 0 if matches == 0  
    return 2**(matches - 1)
  end
end
```



#### File Parsing

One line might look something like this:

      Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53

The first list of numbers are the winning numbers, the second list are your numbers

First, split by colon `": "`

    ["Card 1", "41 48 83 86 17 | 83 86  6 31 17  9 48 53"]

Now you can discard the first part, which is not needed to solve this exercise (the card number is simply decorative)

Split by pipe `" | "` to get both strings of lists

    ["41 48 83 86 17", "83 86  6 31 17  9 48 53"]

Finally, to get each list, split by space `" "`

    ["41", "48", "83", "86", "17"]
    ["83", "86", "6", "31", "17", "9", "48", 53"]


```rb
input.each do |line|
  lists = line.split(": ")[1].split(" | ")
  Card.new(lists[0].split(" "), lists[1].split(" "))
end
```

#### Finally

Just create a list with all the cards and sum the points:

```rb
cards = []
input.each do |line|
  lists = line.split(": ")[1].split(" | ")
  cards.push(Card.new(lists[0].split(" "), lists[1].split(" ")))
end

res = cards.sum {|c| c.get_value}
puts "Result: #{res}"
```

#### More advanced (Perhaps more readable)

The number of matches can also be calculted simply by doing interpolating both the lists, and calculating the size of the resulting array

```rb
matches = (@numbers & @winners).size
```

Although this can only work if there are no repeated values on the winners

### Part 2

For part two, the problem is more complicated, turns out the rules were not quite those presented, turn out the game doesn't give you points like that.<br>
You actually win more cards, each match awards one card<br>
The cards are ordered, for each card, for each match, you are awarded one copy of the next card, and the next card, and so on, for the amount of matches.<br>

For example:

```
Card 1
winners: [1, 3, 4]
numbers: [1, 4, 22, 22, 42] => 2 matches (Awards one copy of Card 2 and one copy of Card 3)

Card 2
winners: [2]
numbers: [1, 2, 21, 42] => 1 match (Awards one copy of Card 3)

Card 3
winners: [99, 100]
numbers: [12, 23, 38, 42] => 0 matches (Awards nothing)
```

On the example above, you end up with 1 instance of Card 1, 2 instances of Card 2 (original + copy awarded by Card 1) & 3 instanced of Card 3 (original + awarded by the other Cards)

You need to find out how many cards you end up with (the copies you won and the original cards)

### Solution Part 2️⃣

We need to change our Card object, since the rules changed, firstly, delete the get_points function, since it is not involved in the new game rules<br>
We need to keep the lists we had before but now need to implement another attribute that is an int which tells us the number of copies

```rb
class Card
  attr_reader :winners, :numbers
  attr_accessor :copies

  def initialize(winners, numbers)
    @winners, @numbers = winners, numbers
    @copies = 1
  end
end
```

I decided to concider the original card as a copy, I don't think it was worth making a distintion between original cards and copies.<br>

We need to know the amount of matches we have, this will help us later to know how many copies of the next cards we won<br>

Using the same logic presented in part one:<br>

```rb
class Card
  def get_matches
    @numbers.size - (@numbers - @winners).size
  end
end
```

Now let implement an algorithm which will help us keep track of all the copies we won.<br>

Since we want to be able to access to different cards and add copies, it's best to implement a map / hash<br>

They key should be the card number (or the line index) as long as it's ordered it's fine<br>

We want this, so if Card 1 has 3 matches, we can easily add one copy to our Card 2, Card 3 & Card 4<br>

So we can change slightly how we parse the cards, instead of saving the cards in an array, implement a hash / map<br>

```rb
cards = {}
input.each_with_index do |line, i|
  lists = line.split(": ")[1].split(" | ")
  cards[i] = Card.new(lists[0].split(" "), lists[1].split(" "))
end
```

Now we can iterate our map and for each card, for all it's copies calculate it's matches, then add all the copies you won, repeat until the end
It is important to know that the copies that you won, ALSO are meant to be played, and they also win more cards.

```rb
cards.each do |i, card|
  card.copies.times do
    card.get_matches.times do |n|
      cards[i + n + 1].copies += 1
    end
  end
end
```

#### Finally

Just add all the copies you founded

```rb
res = cards.sum {|i, c| c.copies}
puts "Result: #{res}"
```

#### More Advanced

You can improve the performance by not calling get_matches every time for each copy, implement an aditional object attribute @matches, and set up the value on initialization.

```rb
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
```

Then you only have to call matches instead of calculating every single time.

GL!<br>
Have fun coding!