input = File.readlines('data.txt', chomp: true)
test_input = <<-EOT
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
EOT

# input = test_input.split("\n")


# LET THEM FALLLL!
def let_it_fall(map, x, y)
  y_after = y - 1
  while y_after != -1
    break if "#O".include?(map[y_after][x])
    y_after -= 1
  end
  map[y_after+1][x] = "O"
end

height = input.length
width = input[0].length

tilted = input.map { |s| s.gsub("O", ".") }
(height * width).times do |i|
  let_it_fall(tilted, i % width, i / height) if input[i / height][i % width] == "O"
end

total = 0
tilted.each_with_index do |t, i|
  total += t.count("O") * (height - i)
end

puts "Total: #{total}"