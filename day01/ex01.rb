file_path = File.expand_path("./../data.txt", __FILE__)
input     = File.read(file_path)
file_data = input.split("\n")

def add_calibrations(data)
  res = 0
  data.each do |line|
    str_only_digits = line.tr('^0-9', '')
    if not str_only_digits[0].nil?
      res += (str_only_digits[0] + str_only_digits[-1]).to_i
    end
  end
  res
end

result = add_calibrations(file_data)
puts "Result: #{result}"
