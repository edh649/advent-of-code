
class Day07
    
  def part1(input) # returning too low... 1260333054159
    lines = input.split("\n")
    result = 0
    lines.each do |line|
      value = line.split(":")[0].to_i
      inputs = line.split(":")[1].split(" ").map { |x| x.to_i }
      if canMakeEquationValid?(value, inputs)
        result += value
      end
    end
    puts result.to_s + "\n"
    return result
  end
  
  def canMakeEquationValid?(value, inputs)
    # can only be + and *
    # 1 2 3 4
    for c in 1..2.pow(inputs.count)
      testValue = inputs[0]
      eq = testValue.to_s
      for i in 1..(inputs.count - 1)
        if c.fdiv(2.pow(i-1)).ceil % 2 == 0
          testValue += inputs[i]
          eq += " + " + inputs[i].to_s
        else
          testValue *= inputs[i]
          eq += " * " + inputs[i].to_s
        end
      end
      # puts eq + " = " + testValue.to_s + "\n"
      if testValue == value
        return true
      end
    end
    return false
  end
  
  def part2(input) # 
    lines = input.split("\n")
    result = 0
    lines.each do |line|
      value = line.split(":")[0].to_i
      inputs = line.split(":")[1].split(" ").map { |x| x.to_i }
      if canMakeEquationValid2?(value, inputs)
        result += value
      end
    end
    puts result.to_s + "\n"
    return result
  end
  
  def canMakeEquationValid2?(value, inputs)
    # can only be + and *
    # 1 2 3 4
    for c in 1..3.pow(inputs.count)
      testValue = inputs[0]
      eq = testValue.to_s
      for i in 1..(inputs.count - 1)
        # fix this
        if c.fdiv(3.pow(i-1)).ceil % 3 == 0
          testValue += inputs[i]
          eq += " + " + inputs[i].to_s
        elsif c.fdiv(3.pow(i-1)).ceil % 3 == 1
          testValue += inputs[i]
          eq += " + " + inputs[i].to_s
        else
          testValue = (testValue.to_s + inputs[i].to_s).to_i
          eq += " || " + inputs[i].to_s
        end
      end
      puts eq + " = " + testValue.to_s + "\n"
      if testValue == value
        return true
      end
    end
    return false
  end
  
end