input = File.readlines('data.txt', chomp: true)
test_input = <<-EOT
???.### 1,1,3
EOT

input = test_input.split("\n")

class String
def green;           "\e[32m#{self}\e[0m" end
def blue;           "\e[34m#{self}\e[0m" end
def magenta;        "\e[35m#{self}\e[0m" end
def bg_gray;        "\e[47m#{self}\e[0m" end
end

# variations = 0

def check_possibilities(records, contiguous, depth = 1, variations = false)
  if records.empty? and contiguous.all?(&:zero?)
    puts (("  " * depth) + "Founded a solution!!!").bg_gray
  end
  return if records.empty?
  puts ("  " * depth) + "Records: " + "#{records}".magenta + " | " + "#{contiguous}".blue
  puts ("  " * depth) + "Could This string work? (does it start with ? or #) : " + "#{"?#".include?(records[0]) and not variations}".green
  if contiguous[0] == 0
    puts ("  " * depth) + "Met the goal, advance to next contiguous"
    check_possibilities(records[1..], contiguous[1..], depth + 1, false)
  elsif records[0] == "#"
    contiguous[0] -= 1
    puts ("  " * depth) + "Continue with Contiguous: #{contiguous}"
  elsif "?".include?(records[0]) and not variations
    # Variations
    puts ("  " * depth) + "Variation1".blue
    check_possibilities("#" + records[1..], contiguous.clone, depth + 1, true)
    puts ("  " * depth) + "End Variation1".blue


    puts ("  " * depth) + "Variation2".blue
    check_possibilities("." + records[1..], contiguous.clone, depth + 1)
    puts ("  " * depth) + "End Variation2".blue
  end
  check_possibilities(records[1..], contiguous, depth + 1)
end



input.each do |line|
  records, contiguous = line.split(" ")
  contiguous = contiguous.split(",").map { |x| x.to_i }
  puts "Spring Records :" + " #{records}".blue
  puts "Contiguous: "+ "#{contiguous}".blue

  check_possibilities(records, contiguous)
end