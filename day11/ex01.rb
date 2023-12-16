input = File.readlines('data.txt', chomp: true)
test_input = <<-EOT
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
EOT

class String
def blue;           "\e[34m#{self}\e[0m" end
def magenta;        "\e[35m#{self}\e[0m" end
def bg_gray;        "\e[47m#{self}\e[0m" end
end

# input = test_input.split("\n")

def add_empty_columns(cols, universe)
  added = 0
  cols.each do |c|
    universe.length.times do |row|
      universe[row].insert(c + added, ".")
    end
    added += 1
  end
  universe
end

expanded_universe = []
input.each_with_index do |line|
  expanded_universe.push(line)
  expanded_universe.push(line + "") if line.split("").filter { |c| c != "." }.empty?
end

len_col = expanded_universe.first.length
len_row = expanded_universe.length

# Filter empty columns
empty_columns = []
len_col.times do |c|
  len_row.times do |r|
    break if expanded_universe[r][c] != "."
    if r == len_row - 1
      empty_columns.push(c)
    end
  end
end

add_empty_columns(empty_columns, expanded_universe)

galaxies = []
expanded_universe.each_with_index do |l, y|
  a = (0 ... l.length).find_all { |i| l[i,1] == '#' }
  a.each do |x|
    galaxies.push([y, x])
  end
end

combinations = galaxies.combination(2).to_a

total_dist = 0
combinations.each do |comb|
  t1 = comb[0]
  t2 = comb[1]

  # puts "For comb: #{comb}"

  x_dist = (t1[0] - t2[0]).abs
  y_dist = (t1[1] - t2[1]).abs
  total = x_dist + y_dist

  # puts "X dist #{x_dist}"
  # puts "Y dist #{y_dist}"
  # puts "Total Distance is #{total}"

  total_dist += total
end


puts "Resutl #{total_dist}"

# galaxies.each do |g|
#   puts "[#{g[0]}, #{g[1]}]"
# end

expanded_universe.each do |l|
  puts l
end
