
class Day19
    
  def part1(input) #between 109 - 324
    towelsInput = input.split("\n")[0].split(",").map(&:strip)
    patterns = input.split("\n")[2..-1].map(&:strip)
    
    baseTowel = TowelColour.new()
    towelsInput.each {|towel| baseTowel.addNextColours(towel) }
      
    patterns.filter! { |pattern| baseTowel.canMakePattern(pattern, baseTowel) > 0 }
    return patterns.length
  end
  
  def part2(input)
    towelsInput = input.split("\n")[0].split(",").map(&:strip)
    patterns = input.split("\n")[2..-1].map(&:strip)
    
    baseTowel = TowelColour.new()
    towelsInput.each {|towel| baseTowel.addNextColours(towel) }
      
    return patterns.sum { |pattern| baseTowel.canMakePattern(pattern, baseTowel)}
  end
  
end

class TowelColour
  attr_accessor :next_colours, :termination, :cache
  
  def initialize()
    @termination = false
    @next_colours = {}
    @cache = {}
  end
  
  def addNextColours(colours)
    if colours == ""
      @termination = true 
      return
    end
    
    @next_colours[colours[0]] = TowelColour.new() unless @next_colours[colours[0]]
    @next_colours[colours[0]].addNextColours(colours[1..-1])
  end
  
  def setReturnCache(pattern, result)
    @cache[pattern] = result
    return result
  end
  
  def canMakePattern(pattern, baseTowel, depth = 0)
    return 0 if pattern.length == 0 && @termination == false
    return 1 if pattern.length == 0 && @termination == true
    
    return @cache[pattern] if @cache[pattern] != nil
    
    #attempt to follow the pattern
    waysOfMaking = 0
    if @next_colours[pattern[0]]
      waysOfMaking += @next_colours[pattern[0]].canMakePattern(pattern[1..-1], baseTowel, depth += 1)
    end
    if @termination #if next colours were bad, terminate here and use baseTowel
      waysOfMaking += baseTowel.canMakePattern(pattern, baseTowel, depth += 1)
    end
    
    return setReturnCache(pattern, waysOfMaking)
  end
  
end