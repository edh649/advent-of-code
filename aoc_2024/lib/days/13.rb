
require "opt-rb"
require "cbc"

class Day13
    
  def part1(input)
    presses = 0
    input.split("\n\n").each do |machine|
      values = machine.scan(/\d+/).map(&:to_i)
      presses += findMinimumButtonPresses(values[0], values[1], values[2], values[3], values[4], values[5])
    end
    return presses
  end
  
  def findMinimumButtonPresses(aX, aY, bX, bY, prizeX, prizeY, prizeOffset = 0)
    a = Opt::Integer.new(0.., "a")
    b = Opt::Integer.new(0.., "b")

    prob = Opt::Problem.new
    prob.add(aX * a + bX * b == (prizeX + prizeOffset))
    prob.add(aY * a + bY * b == (prizeY + prizeOffset))
    prob.minimize(3 * a + b)
    prob.solve
    
    puts "a: #{a.value}, b: #{b.value}"
    return a.value == nil ? 0 : ((3 * a.value) + b.value)
  end
  
  def part2(input) 
    presses = 0
    input.split("\n\n").each do |machine|
      values = machine.scan(/\d+/).map(&:to_i)
      goalX = values[4] + 10000000000000
      goalY = values[5] + 10000000000000
      #resort to Cramer's rule because the CBC solver has a bug and is reporting some feasible solutions as infeasible
      denom = values[0] * values[3] - values[1] * values[2]
      a = (values[3] * goalX - values[2] * goalY).fdiv(denom)
      b = (values[0] * goalY - values[1] * goalX).fdiv(denom)
      if a % 1 == 0 && b % 1 == 0
        thisPress = ((3 * a) + b).ceil
        altPress = findMinimumButtonPresses(values[0], values[1], values[2], values[3], goalX, goalY)
        if thisPress != altPress
          puts "opt-rb/cbc disagrees with Cramer's rule: #{thisPress} vs #{altPress}"
        end
        presses += thisPress
      end
    end
    return presses
  end
  
end