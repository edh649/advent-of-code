
class Day03
    
  def part1(input)
    result = 0
    regex = /mul\(\d{1,3}\,\d{1,3}\)/
    digit_matcher = /\d{1,3}/
    muls = input.scan(regex)
    muls.each do |mul|
      digits = mul.scan(digit_matcher)
      if digits.count != 2
        raise "Unexpected not having 2 sets of digits!"
      end
      result += (digits[0].to_i * digits[1].to_i)
    end
    return result
  end
  
  def part2(input)
    dos = []
    input.split("do()").each do |splitdo|
      this_donts = splitdo.split("don't()")
      dos.append(this_donts[0]) # remove the donts
    end
    result = 0
    dos.each do |valid|
      result += part1(valid)
    end
    return result
  end
  
end