input = File.readlines('data.txt', chomp: true)
test_input = <<-EOT
rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
EOT

# input = test_input.chomp.split(",")
input = input[0].split(",")


total = 0
current_value = 0

input.each do |seq|
  current_value = 0
  seq.length.times do |i|
    ascii_ord = seq[i].ord
    current_value += ascii_ord
    current_value *= 17
    current_value %= 256
  end
  total += current_value
end


puts "Total: #{total}"