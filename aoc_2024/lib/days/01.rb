
class Day01
    
  def part1(input)
    col1 = []
    col2 = []
    i = 0
    input.split(" ").map do |x|
      if i % 2 == 0
        col1 << x
      else
        col2 << x
      end
      i += 1
    end
    
    col1.sort!
    col2.sort!
    
    diff = col1.each_with_index.map { |x,i| (x.to_i - col2[i].to_i).abs }
    
    return diff.sum
  end
  
  def part2(input)
    col1 = []
    col2 = []
    i = 0
    input.split(" ").map do |x|
      if i % 2 == 0
        col1 << x
      else
        col2 << x
      end
      i += 1
    end
    
    sim = 0
    col1.map do |x|
        n_in_col2 = 0
        col2.map do |y| 
            if x == y
              n_in_col2 += 1
            end
        end
        sim += (x.to_i * n_in_col2)
    end
    
    return sim
  end
  
end