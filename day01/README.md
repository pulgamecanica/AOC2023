# AOC Day 01

### Part 1

The probem is simple, append the first and the last digit of every data line<br>
In the exercisse the result of this process is called "calibration"

    For example:

    >1abc2
    >pqr3stu8vwx
    >a1b2c3d4e5f
    >treb7uchet
    
    In this example, the calibration values of these four lines are 12, 38, 15, and 77. Adding these together produces 142.

Your answer should be the addition of the calibration in all the lines given in your data input

### Solution Part 1️⃣

You can simply remove **all** the characters which are not digits, then you just have to append the index 0 and the last index of the resulting string. (using regex would be ideal to remove the characters)

    For example, removing all the characters which are not a digit would look something like this:

    >1abc2          --> 12
    >pqr3stu8vwx    --> 38
    >a1b2c3d4e5f    --> 12345
    >treb7uchet     --> 7

Now you only have to add the index 0 and the last index, in many programming languages, the last index can be access through -1
    
(Remember, that this is a string, and you are adding characters, not numbers, for instance "1" + "2" => "12"):

  ```
    string_only_digits[0] + string_only_digits[-1] => "1" + "2"
  ```

Now you have to convert the result to Integer, for example:

  ```
    (string_only_digits[0] + string_only_digits[-1]).to_i => ("12").to_i = 12
  ```
***

### Part 2

In part two, we need to concider the words `one, two, three, four, five, six, seven, eight, and nine` as valid "digits".

    >two1nine
    >eightwothree
    >abcone2threexyz
    >xtwone3four
    >4nineeightseven2
    >zoneight234
    >7pqrstsixteen

    In this example, the calibration values are 29, 83, 13, 24, 42, 14, and 76. Adding these together produces 281.

In this case, we can't continue with the same logic... unless...

### Solution Part 2️⃣

We can identify when a line of our data input includes any of the given words: 🔍

      Identify if the string contains any of the words

      >pqr3stu8vwx    --> No words found, repeat solution of part one! => 38 ♻️

When any word is found:

      >two1nine  --> two and nine found ✔️


Identify the index and the **first** word founded, and repeat the solution of part one, but in this case from the index 0 until the index of the substring.<br>

#### 🔍 Finding the first word

To facilitate the process of finding the words, I will create a dictionary with the words as keys and their respective values 📖

> Many programming languages have a built in function, to find the first appearance of a substring, in this case, I will refer to this function as `index`<br>
> If a word is found in a lower index, save the word.<br>
> Use an aditional helper variable `i` to keep track of the index of the word founded, the smaller the index the better! Because it means the word was found previously!<br>
>
  ```rb
    # Given that `line` is a line of your input

    numbers_words = {
      "one": 1,
      "two": 2,
      "three": 3,
      "four": 4,
      "five": 5,
      "six": 6,
      "seven": 7,
      "eight": 8,
      "nine": 9,
    }
    i = line.length
    number_words.each do |key, value|
      key = key.to_s
      if (line.include?(key) && line.index(key) < i)
        i = line.index(key)
        res = key
      end
    end
  ```

The code presented above will find the first appearance of a "number" word<br>
The variable `i` starts at `line.length` because that's the least significant index, any index before that would be more important, meaning the word was found before<br>

Now we can just implement the solution of part one, for the substring from 0..`i`, to make sure there are no numbers found **before** our word

      Example

      >eightwothree

> Our algorithm will find the word `eight` at index 0, `two` at index 4 and `three` at index 7<br>
> This means that only `eight` persisted<br>
> Now make sure there are no digits before this word

      Repeat the solution of part one for the substring from 0..0

      >eightwothree[0..0] => "" 

> It will generate a `nil` result, so it won't be concidered! :)

    Another example:

      >mp7one6eightvhfnmfive6

> Our algorithm will find the word `one` at index 3, `eight` at index 7 and `five` at index 17<br>
> This means that only `one` at index 3 persisted<br>
> Now make sure there are no digits before this word

      Repeat the solution of part one for the substring from 0..3

      >mp7one6eightvhfnmfive6[0..3] => "mp7o"

> It will return 7, and so we change the value of the result to 7 `res = 7`


#### 🔍 Finding the last word

For the last appearance, do it similarly, identify the index and the **last** word found, and repeat the solution of part one, but in this case for the substring from index to the end of the string.

> Many programming languages have a built in function to find the last appearance of a substring, in this case, I will refer to this function as `rindex`<br>
> I use an index `i`, but in this case, the most valuable found word is the word with the higher index, because it means we founded it later on the string.<br>
>
  ```rb
    # Given that `line` is a line of your input

    numbers_words = {
      "one": 1,
      "two": 2,
      "three": 3,
      "four": 4,
      "five": 5,
      "six": 6,
      "seven": 7,
      "eight": 8,
      "nine": 9,
    }
    i = -1
    number_words.each do |key, value|
      key = key.to_s
      if (line.include?(key) && line.index(key) > i)
        i = line.index(key)
        res = key
      end
    end
  ```

The code presented above will find the first appearance of a word, and store the word in the res variable<br>
The variable `i` starts at -1 because that's the least significant index, any index after that would be more important, meaning the word was founded after<br>

Now we can just implement the solution of part one, for the substring from `i`..-1, to make sure there are no numbers found **after** our word

      Example

      >eightwothree

> Our algorithm will find the word `eight` at index 0, `two` at index 4 and `three` at index 7<br>
> This means that only `three` persisted<br>
> Now make sure there are no digits before this word

      Repeat the solution of part one for the substring from 7..-1

      >eightwothree[7..-1] => "three" # you can improve the algorithm, and apply only from (index + word.length)

> It will return "", returning a nil value won't be concidered

    Another example:

      >mp7one6eightvhfnmfive6

> Our algorithm will find the word `one` at index 3, `eight` at index 7 and `five` at index 17<br>
> This means that only `five` at index 17 persisted<br>
> Now make sure there are no digits after this word

      Repeat the solution of part one for the substring from 17..-1

      >mp7one6eightvhfnmfive6[17..-1] => "five6"

> It will return 6, and so we change the value of the result to 6 `res = 6`

### Finally

Then you only need to append both your string found, if the string is not numeric, convert it before you append it.<br>
You can do it using the map `numbers_words[word]` will return the value corresponding the word.

GL!
Have fun coding!