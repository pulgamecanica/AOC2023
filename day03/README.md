# AOC Day 03

### Part 1

This time, you must help the elves with their broken gondola gear!<br>
You are given an input file which represents the engine. There are numbers and symbols in the engine.<br>
Concider numbers as a chain of digits ("0123456789") horizontally. <br>
Symbols are represented by other characters which are not digits.<br>
(Periods (.) do not count as a symbol.)<br>

For example:

```
...42..
.%..#..
..991..
.....*.
```
In the engine above we can identify two numbers `42` & `991`
There are also 3 symbols: [ %, #, * ]

A `"part number"` is any number adjacent to a symbol (diagonals included)<br>
Your job is to calculate the sum of all the `"part numbers"` in the engine.<br>

<!--
<images showing examples to be appended later>
-->

### Solution Part 1️⃣

To solve this problem I took a very literal approach.<br>
Identify all the numbers in the engine, for each number, identify all it's neighbors.<br>
Calculate the sum of all the numbers wich are `"part numbers"`

```rb
class EngineNumber
  attr_reader :value, :neighbors

  def initialize(value)
    @value = value
    @neighbors = []
    puts "Initialized [#{value}]"
  end
end
```

> As you can see it is quite straigh forward, we have an EngineNumber, which contains the number itself `value` and an array with it's neighbors

We should create a function which evaluates an EngineNumber and tells if it is a part number or not (adjacent `any` to a symbol)

```rb
class EngineNumber
  ...

  def isPartNumber?
    return (@neighbors.filter { |neighbor| not ".0123456789".include?(neighbor)}).any?
  end
end
```

> Filter all the neighbors which are a period or a digit, if there are `any` neighbors left, it means there is at least one symbol neoghbor


Now all we have to do is to parse the data<br>
The most tricky part about this, is finding **all** the neighbors of a number, for example:

```
.*....
.4200.
...@..
```

> The number 4200 has 6 neighbors in the north, 2 neighbors to it's sides & 6 neighbors to the south

```
...
.42
@..
```
> In the eaxmple above, the number is exactly at the end of the line (that's why there are no neighbors to the right)<br>
> In this case the number 42 has 3 neighbors in the north, 1 neighbors to it's left & 3 neighbors to the south

You will find out how simple this actually is!

#### File Parsing

##### 1 For each line, read every character, ignore all characters except digits.<br>

##### 2 When a digit is found, save the index where the digit starts, continue iterating until you no longer find more digits<br>

Visual example:

```
. . . . * . . . 1 2 3 . . .
| | | | | | | | |_______ Founded digit '1', save start_index = index [8]
| | | | | | | |
| | | | | | | |_________ Ignored [7]
| | | | | | | 
| | | | | | |___________ Ignored [6]
| | | | | |
| | | | | |_____________ Ignored [5]
| | | | | 
| | | | |_______________ Ignored [4]
| | | |
| | | |_________________ Ignored [3]
| | | 
| | |___________________ Ignored [2]
| |
| |_____________________ Ignored [1]
|
|_______________________ Ignored [index = 0]
```

Iteration until you no longer find digits

```
1 2 3 . . .
| | | |
| | | |_ Not a digit, stop
| | |
| | |___ Founded "3", next [index += 1]
| |
| |_____ Founded "2", next [index += 1]
|
|_______ Founded "1", next [index += 1]
```


Let `file_data` be an array or all the data input lines
```rb
file_data.each_with_index do |line, y|
  i = 0
  while i < line.length
    start_i = i
    i += 1 while i < line.length and "0123456789".include?(line[i])
    # At this point, if the line contains a number, it will be between start_i and i [start_i...i]
    i += 1
  end
end
```

We start iterating our line with an iterator `i`<br>
Save the index and continue incrementing `i` `while` digit found<br>

##### 3 Parse the number, you can simply extract the substring [start_index...index] from the string and convert the string to a number

For the example presented above, it would be:

```
"....*...123..."[8...11] => "123"
"....*...123..."[8...11].to_i = 123

```

```rb
...
if line[start_i...i].to_i != 0 
  element = EngineNumber.new(line[start_i...i].to_i)
end
...
```

##### 4 For an EngineNumber found, register all it's neighbors and add the EngineNumber to a list

> Remember, when we iterated our file input lines we user each_with_index and registered the line number in a variable `y`
>
> The possible neighbors of a number are: 
>
> Let N be where the number start, and M where the number ends
>
> Concider N and M as index of the number

```
??????
?N--M?
??????
```
The neighbors are not coordinates, they are array accesses<br>
For instance `[0, 1]` means `file_input[0][1]`<br>
`neighbor <=> [line, index]`<br>
The neighbors can be defined with the following equation<br>

    Let len = lenght of the number (`len = M - N`)

    **Side neighbors**

    [0, -1] => Neighbor to the left of N (unabailable when N == 0)

    [0, len] => Neighbor to the right of M (unabailable when M is the last character of the string)

    **North neighbors**

    Concider a range from [-1 .. len] (no need to do len + 1 because the range includes 0)

    For example, let the number be 42 (42 has a len = 2), we would have the range from [-1..2] => [-1, 0, 1, 2]

    This describes all the neighbors, left to the right

    [-1..len] each |e|
      [-1, e] => Neighbors starting from the neighbor at [-1, -1] until [-1, len] (unavailable when the line is the first one) (unavailable if N + e < 0) (unavailable if N + e >= line.lenght)
    end

    Let's analize the unavailable conditions:

    If it's the first line, there are no neighbors to the north

    If N is the first character of the line, there are no neighbors to the left, doing N + e will return the index of the neighbor, when N + e < 0 it means, the index doesn't exist (there is no negative index)

    If N + e >= line.lenght it means the neighbor also doesn't exist, there is no index >= than the line.lenght

    **South neighbors**

    Using the same logic exactly as with the north exept this time, we use [1, e] and the first unavailable condition changes to:

    (unavailable when the line is the last one) Last line has no neighbors to the south

```rb
# N = x, M = x + lens
def get_neighbors(width, height, x, y, len)
  neighbors = []

  neighbors.push([0, -1])   if x > 0
  neighbors.push([0, len])  if x + len < width - 1

  [1, -1].each do |direction|
    (-1..len).each do |to_east|
      neighbors.push([direction, to_east]) if (direction + y >= 0 && y + direction < height) and (to_east + x > 0 && to_east + x < width - 1)
    end
  end
  return neighbors
end
```

Finally, to register the neighbors, add all the neighbors to the EngineNumber neighbors list<br>
Add the element to the list

```rb
list_of_engine_numbers = []
...
if line[start_i...i].to_i != 0 
  element = EngineNumber.new(line[start_i...i].to_i)
  # i - start_i == len
  neighbors = get_neighbors(line.length, file_data.length, start_i, y, i - start_i)
  neighbors.each do |n|
    element.neighbors.push(file_data[y + n[0]][start_i + n[1]])
  end
  list_of_engine_numbers.push(element)
end
...
```

#### Finally

To find your answer you have to sum all the engine numbers which are part_number:

```rb
res = list_of_engine_numbers.sum { |elem| elem.partNumber? ?  elem.value : 0}
puts "Result : #{res}"
```

***

### Solution Part 2️⃣

Now you are presented with a slightly different problem<br>
You should find all the **gears** of the engine and return the sum of all the **gear ratios**<br>

A gear is any _"*"_ which is adjacent to exactly two part numbers<br>
The gear ratio is the product of the two part numbers<br>

The solution of this problem is simpler than it might appear.

We should continue with our strategy of parsing all the Engine Numbers.<br>

We are also going to concider the new element of this challenge, the `Gear`<br>

And this time when we find a a gear we are going to create a `Gear`<br>
It defines it's position and it's adjacent Engine Numbers

```rb
class Gear
  attr_reader :x, :y, :engine_numbers

  def initialize(x, y)
    @x = x
    @y = y
    @engine_numbers = []
  end
end
```

Now we can create one function to compute if the Gear is valid (adjacent exactly to two part numbers) and a function which returns the gear ratio<br>
Of course, take advantage of the partNumber? to determine if the adjacent number is or not a part number

```rb
class Gear
  ...

  def valid?
    return (@engine_numbers.filter { |neighbor| neighbor.partNumber? }).size == 2
  end

  def part_numbers_neighbors_product
    if valid?
      a = @engine_numbers.filter { |neighbor| neighbor.partNumber? }
      return a[0].value * a[1].value
    end
    return 0
  end
end
```

To solve this problem we only need to add a few lines.<br>

We have parsed all the engine numbers found (in part 1)<br>

##### 1 Register all gears founded as Engine Number neighbors

Gears are unique that is why we have saved it's position: @x, @y<br>

We must keep a list of the gears created<br>

If the neighbor is an asterisk " * ", identify the gear (create or find in the list)<br>

Add the current engine number to the list of `@engine_numbers` of the Gear<br>

> We will no longer require the list `list_of_engine_numbers`
>
> You can change the name of the list and replace with `gears = []`

```rb
  gears = []
  ...
  neighbors.each do |n|
    element.neighbors.push(file_data[y + n[0]][start_i + n[1]])
    if file_data[y + n[0]][start_i + n[1]] == "*"
      gear = gears.find {|gear| gear.x == start_i + n[1] && gear.y == y + n[0]}
      if (gear.nil?)
        gear = Gear.new(start_i + n[1], y + n[0])
        gears.push(gear)
      end
      gear.engine_numbers.push(element)

    end
  end

```

> Notice we use `gears.find {...}` to make sure the gear doesn't exists already

#### 2 Now all there is left to do is to sum all the products of the valid gears<br>

```rb
res = gears.sum { |gear| gear.valid? ? gear.part_numbers_neighbors_product : 0}
puts "Result : #{res}"
```

GL!<br>
Have fun coding!