file_path = File.expand_path("./../data.txt", __FILE__)
input     = File.read(file_path)
file_data = input.split("\n")

$number_words = {
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

class String
  def get_first_number_word
    res = nil
    i = self.length

    $number_words.each do |key, value|
      key = key.to_s
      if (self.include?(key) && self.index(key) < i)
        i = self.index(key)
        res = $number_words[key.to_sym]
      end
    end
    str_only_digits = self[0...i].tr('^0-9', '')
    if not str_only_digits[0].nil?
      res = str_only_digits[0]
    end
    res
  end

  def get_last_number_word
    res = nil
    i = 0

    $number_words.each do |key, value|
      key = key.to_s
      if (self.include?(key) && self.rindex(key) >= i)
        i = self.rindex(key)
        res = $number_words[key.to_sym]
      end
    end
    str_only_digits = self[i..-1].tr('^0-9', '')
    if not str_only_digits[0].nil?
      res = str_only_digits[-1]
    end
    res
  end

  def numeric?
    Float(self) != nil rescue false
  end
end

def add_calibrations(data)
  res = 0
  data.each do |line|
    res += (line.get_first_number_word.to_s + line.get_last_number_word.to_s).to_i
  end
  res
end

result = add_calibrations(file_data)
puts "Result #{result}"
