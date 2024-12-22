
class Day22
    
  def part1(input)
    input.split("\n").map(&:to_i).sum do |initial|
      0.upto(1999).each { initial = iteratePseudorandom(initial) }
      initial
    end
  end
  
  def iteratePseudorandom(v)
    a = v * 64
    v = mix(a, v)
    v = prune(v)
    
    b = v.fdiv(32).floor
    v = mix(b, v)
    v = prune(v)
    
    c = v * 2048
    v = mix(c, v)
    v = prune(v)
  end
  
  def mix(into, base)
    into^base
  end
  
  def prune(v)
    v % 16777216
  end
  
  def part2(input) #1864 too high
    pList = input.split("\n").map(&:to_i).map do |initial|
      prices, priceChanges = calculatePriceChanges(initial)
      next [prices, priceChanges]
    end
    sequenceScores = {}
    
    pList.each do |prices, priceChanges|
      theseSequenceScores = {}
      for i in 3..(priceChanges.length - 1)
        theseSequenceScores[priceChanges[i-3..i]] = prices[i] if theseSequenceScores[priceChanges[i-3..i]].nil?
      end
      sequenceScores.merge!(theseSequenceScores) { |key, oldVal, newVal| oldVal + newVal }
    end
    
    return sequenceScores.values.max
  end
  
  def calculatePriceChanges(initial)
    prices = []
    priceChanges = []
    prevPrice = initial % 10
    0.upto(1999).each {
      initial = iteratePseudorandom(initial)
      price = initial % 10
      prices << price
      priceChanges << price - prevPrice
      prevPrice = price
    }
    return prices, priceChanges
  end
  
end