
class Day11
    
  def part1(input)
    stones = input.split(" ").map(&:to_i)
    for i in 1..25
      puts "\ni: #{i}"
      stones.map! do |stone|
        if stone == 0
          stone = 1
        elsif stone.digits.count % 2 == 0
          stone1 = stone.digits[0..(stone.digits.count/2)-1].each_with_index.sum { |value, index| value * (10.pow(index)) }
          stone2 = stone.digits[(stone.digits.count/2)..-1].each_with_index.sum { |value, index| value * (10.pow(index)) }
          stone = [stone1, stone2]
        else
          stone *= 2024
        end
      end
      stones.flatten!
    end
    stones.count
  end
  
  def part2(input)
    stones = input.split(" ").map(&:to_i)
    stonesMap = {}
    stones.each { |stone| stonesMap[stone] = 1 }
    for i in 1..75
      puts "\ni: #{i}"
      nextStonesMap = {}
      stonesMap.each do |stone, count|
        if stone == 0
          nextStonesMap.key?(1) ? nextStonesMap[1] += count : nextStonesMap[1] = count
        elsif stone.digits.count % 2 == 0
          stone1 = stone.digits[0..(stone.digits.count/2)-1].each_with_index.sum { |value, index| value * (10.pow(index)) }
          stone2 = stone.digits[(stone.digits.count/2)..-1].each_with_index.sum { |value, index| value * (10.pow(index)) }
          nextStonesMap.key?(stone1) ? nextStonesMap[stone1] += count : nextStonesMap[stone1] = count
          nextStonesMap.key?(stone2) ? nextStonesMap[stone2] += count : nextStonesMap[stone2] = count
        else
          nextStonesMap.key?(stone*2024) ? nextStonesMap[stone * 2024] += count : nextStonesMap[stone * 2024] = count
        end
      end
      stonesMap = nextStonesMap
    end
    stonesMap.sum{|v, c| c}
  end
  
end