input = File.readlines('data.txt', chomp: true)
test_input = <<-EOT
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
EOT
input = test_input.split("\n")

class OasisData
  attr_reader :sequences

  def initialize(seq)
    @sequences = [seq]
    while not is_sequence_zeroes(seq)
      seq = get_next_sequence(seq)
      @sequences.push(seq)
    end
    @sequences.reverse!
    @sequences.each_with_index do |s, i|
      s.reverse!
      next if (i == 0)
      s.push((s.last - @sequences[i - 1].last))
    end
  end

  private
    def get_next_sequence(seq)
      next_seq = []
      i = 0
      j = 1
      while (j < seq.length)
        next_seq.push(seq[j] - seq[i])
        j += 1
        i +=1
      end
      next_seq
    end

    def is_sequence_zeroes(seq)
      seq.all?(&:zero?)
    end
end

oasis = []
input.each do |line|
  oasis.push(OasisData.new(line.split(" ").map {|x| x.to_i}))
end

sum = 0
oasis.each do |o|
  sum += o.sequences.last.last
end

puts "#{sum}"
