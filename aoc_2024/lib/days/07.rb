
class Day07
    
  def part1(input) # returning too low... 976568637658
    lines = input.split("\n")
    result = 0
    lines.each do |line|
      value = line.split(":")[0].to_i
      inputs = line.split(":")[1].split(" ").map { |x| x.to_i }
      if canMakeEquationValid?(value, inputs)
        result += value
      end
    end
    puts result
    return result
  end
  
  def canMakeEquationValid?(value, inputs)
    # can only be + and *
    # 1 2 3 4
    for i in 0..(inputs.count - 1)
      for ii in 0..(inputs.count - 1)
        testValue = inputs[0]
        eq = testValue.to_s
        for n in 1..(inputs.count - 1)
          if ii == n
            testValue *= inputs[n]
            eq += " * " + inputs[n].to_s
          else
            if i < n
              testValue += inputs[n]
              eq += " + " + inputs[n].to_s
            else
              testValue *= inputs[n]
              eq += " * " + inputs[n].to_s
            end
          end
        end
        # puts eq + " = " + testValue.to_s + "\n"
        if testValue == value
          return true
        end
      end
    end
    return false
  end
  
  def part2(input)
   
  end
  
end