input = File.readlines('data.txt', chomp: true)
test_input = <<-EOT
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
EOT

input = test_input.split("\n")

s = 0

def possible(contiguous, records, continue)
  return 1 if records.empty? and contiguous.empty?
  
  return 1 if records.empty? and contiguous.all?(&:zero?)

  return 0 if records.empty? and not contiguous.empty?
      
  return (records.index("#").nil? ? 1 : 0) if contiguous.empty?

  if contiguous[0].zero?
    if '.?'.include?(records[0])
      return possible(contiguous[1..], records[1..], false)
    end
    return 0
  end

  if records[0] == '.' and not continue
    return possible(contiguous, records[1..], false)
  elsif records[0] == '#'
    return possible([(contiguous[0] - 1), contiguous[1..]], records[1..], true)
  elsif records[0] == "?"
    s = continue ? 0 : possible(contiguous, '.' + records[1..], continue)
    return s + possible(contiguous, '#' + records[1..], continue)
  end
  return 0
end


total = 0
input.each do |line|
  records, contiguous = line.split(" ")
  contiguous = contiguous.split(",").map { |x| x.to_i }
  puts "Spring Records :" + " #{records}"
  puts "Contiguous: "+ "#{contiguous}"

  t = possible(contiguous, records, false)
  puts "Total: #{t}"
  total += t
end

puts "Result: #{total}"

