input = File.readlines('data.txt', chomp: true)
test_input = <<-EOT
rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
EOT

input = test_input.chomp.split(",")
# input = input[0].split(",")


hash_map = {}
256.times { |i| hash_map[i] = {} }

input.each do |seq|
  label = 0
  2.times do |i|
    ascii_ord = seq[i].ord
    label += ascii_ord
    label *= 17
    label %= 256
  end
  lens_slots = seq[3]
  if lens_slots.nil? # Then it's -
    if not hash_map[label][seq[0...2]].nil?
      hash_map[label].filter! {|key, val| key != seq[0...2]}
    end
  else
    hash_map[label][seq[0...2]] = seq[3].to_i
  end
end

hash_map = hash_map.filter { |key, val| not val.empty? }

total = 0
hash_map.each do |key, labels|
  labels.each_with_index do |(label, focal_length), i|
    next if focal_length.nil?
    focusing_power = (key + 1) * (i + 1) * focal_length 
    puts "For Box #{key}, label #{label}: #{(key + 1)} * #{(i + 1)} * #{focal_length}"
    total += focusing_power
  end
end


# puts "#{hash_map}"


puts "Total: #{total}"