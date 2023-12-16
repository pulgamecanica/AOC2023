input = File.readlines('data.txt', chomp: true)
test_input = <<-EOT
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
EOT

MULTIPLIER = 1

input = test_input.split("\n")

s = 0

def possible(contiguous, records, continue, cache)
    if cache.has_key?([contiguous, records, continue])
        return cache[[contiguous, records, continue]]

    end

    if records.empty? and contiguous.empty?
        cache[[contiguous, records, continue]] = 1
        return 1
    end


    if records.empty? and contiguous.all?(&:zero?)
        cache[[contiguous, records, continue]] = 1
        return 1
    end

    if records.empty? and not contiguous.empty?
        cache[[contiguous, records, continue]] = 0
        return 0
    end

    if contiguous.empty?
        result = (records.index("#").nil? ? 1 : 0)
        cache[[contiguous, records, continue]] = result
        return result
    end

  if contiguous[0].zero?
    if '.?'.include?(records[0])
        result = possible(contiguous[1..], records[1..], false, cache)
        cache[[contiguous, records, continue]] = result
        return result
    end
    cache[[contiguous, records, continue]] = 0
    return 0
  end

  if records[0] == '.' and not continue
    return possible(contiguous, records[1..], false, cache)
  elsif records[0] == '#'
    contiguous2 = contiguous.clone
    contiguous2[0] -= 1
    return possible(contiguous2, records[1..], true, cache)
  elsif records[0] == "?"
    s = continue ? 0 : possible(contiguous, '.' + records[1..], continue, cache)
    return s + possible(contiguous, '#' + records[1..], continue, cache)
  end
  return 0
end

total = 0
input.each do |line|
  records, contiguous = line.split(" ")
  contiguous = contiguous.split(",").map { |x| x.to_i }
  records = records + '?' + records + '?' + records + '?' + records + '?' + records
  contiguous*=5
  puts "Spring Records :" + " #{records}"
  puts "Contiguous: "+ "#{contiguous}"

  t = possible(contiguous, records, false, Hash::new)
  puts "Total: #{t}"
  total += t
end

puts "Result: #{total}"