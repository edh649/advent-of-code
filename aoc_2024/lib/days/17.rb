
class Day17
    
  def part1(input)
    setupInput(input)
    return runProgram()
  end
  
  def runProgram()
    i = 0
    while @pointer < @program.length
      i += 1
      if i > 1000
        raise ArgumentError, "Infinite loop detected"
      end
      stepProgram
      if @stopIfOutputProgramMismatch && @output.length() > 0 && @output != @program[0..(@output.length() - 1)]
        break
      end
    end
    return @output.join(",")
  end
  
  def setupInput(input)
    splits = input.split("\n")
    @registerA = splits[0].split(":")[1].strip.to_i
    @registerB = splits[1].split(":")[1].strip.to_i
    @registerC = splits[2].split(":")[1].strip.to_i
    @program = splits[4].split(":")[1].strip.split(",").map(&:to_i)
    @pointer = 0
    @output = []
    @stopIfOutputProgramMismatch = false
  end
  
  def stepProgram()
    instruction = @program[@pointer]
    arg = @program[@pointer + 1]
    case instruction
    when 0
      adv(arg)
    when 1
      bxl(arg)
    when 2
      bst(arg)
    when 3
      jnz(arg)
    when 4
      bxc(arg)
    when 5
      out(arg)
    when 6
      bdv(arg)
    when 7
      cdv(arg)
    end
    @pointer += 2
  end
  
  def adv(arg)
    @registerA = @registerA.fdiv(2.pow(comboOperand(arg))).truncate
  end
  
  def bdv(arg)
    @registerB = @registerA.fdiv(2.pow(comboOperand(arg))).truncate
  end
  
  def cdv(arg)
    @registerC = @registerA.fdiv(2.pow(comboOperand(arg))).truncate
  end
  
  def bxl(arg)
    @registerB = @registerB ^ arg
  end
  
  def bst(arg)
    @registerB = comboOperand(arg) % 8
  end
  
  def jnz(arg)
    if @registerA != 0
      @pointer = (arg - 2) #-2 to pre-empt iteration
    end
  end
  
  def bxc(arg)
    @registerB = @registerB ^ @registerC
  end
  
  def out(arg)
    @output.append(comboOperand(arg) % 8)
  end
  
  def comboOperand(arg)
    case arg
    when 0..3
      return arg
    when 4
      return @registerA
    when 5
      return @registerB
    when 6
      return @registerC
    when 7
      raise ArgumentError, "Invalid operand"
    end
  end
  
  def investigate()
    @stopIfOutputProgramMismatch = false
    i = 0
    while i < 10000000
      if i % 100000 == 0
        puts "\n"
        puts "Iteration #{i}"
      end
      runForRegisterA(i + 130400761918224)
      if @output == @program
        puts "found match at #{i}"
        return i
      end
      # puts "#{i}: " + @output.join(",")
      # puts "\n"
      i += 1
    end
    puts "No match found within #{i} iterations"
    return i
  end
  
  def runForRegisterA(regA)
    @registerA = regA
    @registerB = 0 #manual from input
    @registerC = 0 #manual from input
    @pointer = 0
    @output = []
    runProgram()
  end
  
  def part2(input) # 130400761918224 too low
    setupInput(input)
    investigate()
    flippedInt = (@program.dup.reverse.join("").to_i * 10)
    # convert base 8 to base 10
    b8 = flippedInt.to_s().to_i(8).to_s(10)
    initial = b8.to_i
  end
  
  
end