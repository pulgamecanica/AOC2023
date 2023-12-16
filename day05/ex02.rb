test_input = <<-EOT
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
EOT
test_input = test_input.split("\n")

class String
def blue;           "\e[34m#{self}\e[0m" end
def magenta;        "\e[35m#{self}\e[0m" end
def bg_gray;        "\e[47m#{self}\e[0m" end
end


input = test_input

map_start, map_end = 0
maps = []
input.each_with_index do |line, i|
  if (line.include?("map"))
    map_end = i
    while not (input[map_end].nil? or input[map_end].empty?)
      map_end += 1 
    end
    maps.push([line.split(" ")[0], input[(i + 1)...map_end].map { |e| e.split(" ").map { |n| n.to_i } }])
  end
end


box_size = ARGV[0].nil? ? 15 : ARGV[0].to_i < 10 ? 15 : ARGV[0].to_i
maps.each do |m|
  puts "┌".bg_gray.magenta + "─".bg_gray.magenta*(box_size * 2 + 3) + "┐".bg_gray.magenta
  i_str = "│".bg_gray.magenta

  puts i_str + "%#{box_size}.#{box_size}s | %-#{box_size}.#{box_size}s".blue % [m[0].split("-")[0], m[0].split("-")[2]] + i_str
  m[1].sort! { |a, b| a[1] <=> b[1] }
  m[1].each do |rules|
    src = rules[0]
    dest = rules[1]
    len = rules[2]
    
    puts i_str + ("-"*box_size) + " | " + ("-"*box_size) + i_str

    puts i_str + "% #{box_size}d | %- #{box_size}d" % [dest, src] + i_str
    puts i_str + ("%-#{box_size*2 + 3}s" % [(" "*(box_size - 3)) + "... | ...jump %.2d" % [len]]) + i_str
    puts i_str + "% #{box_size}d | %- #{box_size}d" % [dest + len - 1, src + len - 1] + i_str
  end
  puts "└".bg_gray.magenta + "─".bg_gray.magenta*(box_size * 2 + 3) + "┘".bg_gray.magenta
  puts "\n"
end