input = File.readlines('data.txt', chomp: true)
test_input = <<-EOT
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
EOT

# input = test_input.split("\n")

# class String
# def green;          "\e[32m#{self}\e[0m" end
# def blue;           "\e[34m#{self}\e[0m" end
# def magenta;        "\e[35m#{self}\e[0m" end
# def red;            "\e[31m#{self}\e[0m" end
# def bg_gray;        "\e[47m#{self}\e[0m" end
# end

# def highlight_col_pattern(pattern, i)
#   if (i == -1)
#     puts "No mirror founded".red
#   else
#     puts "  " + " " * i + "#{i}#{i+1}".magenta
#   end
#   pattern.each do |line|
#     print "  "
#     line.length.times do |c|
#       if i != -1 and (c == i or c == i + 1)
#         print line[c].blue
#       else
#         print line[c]
#       end
#     end
#     puts
#   end
#   puts "-" * (pattern[0].length + 3)
# end

# def highlight_row_pattern(pattern, i)
#   if (i == -1)
#     puts "No mirror founded".red
#   end
#   pattern.each_with_index do |line, line_i|
#     if i != -1 and (line_i == i or line_i == i + 1)
#       puts "%-2d".magenta % [line_i] + line.blue
#     else
#       puts "  " + line
#     end
#   end
#   puts "-" * (pattern[0].length + 3)
# end

def is_reflection(pattern, start)
  i, j = start, start + 1
  while i >= 0 and j < pattern.length
    return false if (pattern[i] != pattern[j])
    j += 1
    i -= 1
  end
  return true
end

def find_mirror(pattern)
  j = 1
  (pattern.length - 1).times do |i|
    return i if is_reflection(pattern, i)
    j += 1
  end
  return -1
end

def rotate_pattern(pattern)
  rotated_patern = Array.new(pattern[0].length)
  pattern.each do |str|
    str.length.times do |i|
      rotated_patern[i] = (rotated_patern[i] || "") + str[i]
    end
  end
  return rotated_patern
end

patterns = []
last = 0
input.each_with_index do |line, i|
  if line.chomp.empty?
    patterns.push(input[last...i])
    last = i + 1
  elsif i == input.length - 1
    patterns.push(input[last..i])
  end
end

total_rows = 0
total_cols = 0
patterns.each do |pattern|
  rotated_patern = rotate_pattern(pattern)
  res_row = find_mirror(pattern)
  res_col = find_mirror(rotated_patern)
  if res_row != -1
    total_rows += res_row + 1
    # highlight_row_pattern(pattern, res_row);
  elsif res_col != -1
    total_cols += res_col + 1
    # highlight_col_pattern(pattern, res_col);
  end
end

puts "Rows: #{total_rows} Cols: #{total_cols}"
total = total_cols + (100 * total_rows)
puts "Total: #{total}"
