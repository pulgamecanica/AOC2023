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

EMPTY_SIZE = 1000000

input = test_input.split("\n")

expanded_universe = []
empty_rows = []
input.each_with_index do |line, i|
  expanded_universe.push(line)
  empty_rows.push(i) if line.split("").filter { |c| c != "." }.empty?
end

len_col = expanded_universe.first.length
len_row = expanded_universe.length

empty_columns = []
len_col.times do |c|
  len_row.times do |r|
    break if expanded_universe[r][c] != "."
    if r == len_row - 1
      empty_columns.push(c)
    end
  end
end

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
  horizontal_range = ([t1[1], t2[1]].min..[t1[1], t2[1]].max)
  vertical_range = ([t1[0], t2[0]].min..[t1[0], t2[0]].max)
  # puts "Did I pass through huge space? H #{empty_columns}, V #{empty_rows}"
  # puts "My Way: H #{horizontal_range}, V #{vertical_range}"
  # Horizontal space check 
  horizontal_range.each do |h_r|
    next if not empty_columns.include?(h_r)
    x_dist -= 1
    x_dist += EMPTY_SIZE
  end

  vertical_range.each do |v_r|
    next if not empty_rows.include?(v_r)
    y_dist -= 1
    y_dist += EMPTY_SIZE
  end
  # puts "Real X dist #{x_dist}"
  # puts "Real Y dist #{y_dist}"
  total = x_dist + y_dist
  # puts "Real Total Distance is #{total}"
  total_dist += total
end

puts "Resutl #{total_dist}"
