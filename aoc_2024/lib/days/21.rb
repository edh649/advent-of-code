
class Day21
    
  def part1(input)
    part2(input, 2)
  end
  
  def generateNumericalPadPaths()
    numericalPad = [
      ['7', '8', '9'],
      ['4', '5', '6'],
      ['1', '2', '3'],
      ['X', '0', 'A']
    ]
    @numericalPadPaths = {}
    
    for i in 0..2
      for j in 0..3
        for x in 0..2
          for y in 0..3
            start = numericalPad[j][i]
            finish = numericalPad[y][x]
            pattern = ''
            deltaX = i - x
            deltaY = j - y
            
            pattern += "<" * deltaX if deltaX > 0
            pattern += ">" * deltaX.abs if deltaX < 0
            pattern += "^" * deltaY if deltaY > 0
            pattern += "v" * deltaY.abs if deltaY < 0
            
            #get all possible permutations of the pattern
            patterns = pattern.chars.permutation.map(&:join).uniq
            
            patterns.filter! do |p|
              next false if start == 'A' && p[0..1] == '<<'
              next false if start == '0' && p[0] == '<'
              next false if start == '1' && p[0] == 'v'
              next false if start == '4' && p[0..1] == 'vv'
              next false if start == '7' && p[0..2] == 'vvv'
              next true
            end
            
            @numericalPadPaths[[start, finish]] = patterns
          end
        end
      end
    end
  end
  
  
  def generateDirectionalPadPaths()
    directionalPad = [
      ['X', '^', 'A'],
      ['<', 'v', '>']
    ]
    @directionalPadPaths = {}
    
    for i in 0..2
      for j in 0..1
        for x in 0..2
          for y in 0..1
            start = directionalPad[j][i]
            finish = directionalPad[y][x]
            pattern = ''
            deltaX = i - x
            deltaY = j - y
            
            pattern += "<" * deltaX if deltaX > 0
            pattern += ">" * deltaX.abs if deltaX < 0
            pattern += "^" * deltaY if deltaY > 0
            pattern += "v" * deltaY.abs if deltaY < 0
            
            #get all possible permutations of the pattern
            patterns = pattern.chars.permutation.map(&:join).uniq
            
            patterns.filter! do |p|
              next false if start == '<' && p[0] == '^'
              next false if start == '^' && p[0] == '<'
              next false if start == 'A' && p[0..1] == '<<'
              next true
            end
            
            @directionalPadPaths[[start, finish]] = patterns
          end
        end
      end
    end
  end
  
  
  def getNumericalPadPaths(desiredInput)
    directions = []
    
    moves = "A" + desiredInput # always starts at A
    
    for i in 0..moves.length - 2
      currentPos = moves[i]
      nextPos = moves[i + 1]
      
      movePaths = @numericalPadPaths[[currentPos, nextPos]].map {|r| r + "A"} # add the 'pushing' the button for each
      
      directions[i] = movePaths
    end
    
    dirs = directions.map(&:uniq).first.product(*directions.drop(1)) # https://stackoverflow.com/questions/43813834/how-to-recursively-find-permutations-of-two-dimensional-array-in-ruby
    return dirs.map(&:join)
  end
  
  def getDirectionalPadPaths(desiredInput, startPush = true, midPush = true)
    directions = []
    
    moves = desiredInput
    moves = "A" + moves if startPush # always starts at A
    for i in 0..moves.length - 2
      currentPos = moves[i]
      nextPos = moves[i + 1]
      
      movePaths = @directionalPadPaths[[currentPos, nextPos]]
      movePaths.map { |p| p += "A" } if midPush
      
      directions[i] = movePaths
    end
    
    directions.uniq!
    if directions == [[""]]
      return [""]
    end
    
    dirs = directions.map(&:uniq).first.product(*directions.drop(1)) # https://stackoverflow.com/questions/43813834/how-to-recursively-find-permutations-of-two-dimensional-array-in-ruby
    return dirs.map(&:join)
  end
  
  def part2(input, depth = 12)
    generateNumericalPadPaths()
    generateDirectionalPadPaths()
    calculateBuildingBlocks()
    puts "calculated building blocks"
    return input.split("\n").sum do |line|
      puts "processing line: #{line} \n"
      numberPadInput = getNumericalPadPaths(line)
      score = numberPadInput.map {|nI| generateStringForLevel(nI, depth).length }.min
      code = /(\d+)/.match(line)[0].to_i
      next score * code
    end
  end
  
  def generateStringForLevel(input, level)
    if level == 0
      return input
    end
    
    nextInput = (@buildingBlocks["A" + input[0]] || "") + "A" #first go from the previous action to the first place (and click it)
    for i in 0..input.length - 2
      nextInput += (@buildingBlocks[input[i..i + 1]] || "") + "A" #and click it!
    end
    # puts "\n " + level.to_s + ": " + nextInput.length.to_s + "\n"
    return generateStringForLevel(nextInput, level - 1)
  end
  
  def calculateBuildingBlocks()
    @buildingBlocks = {}
    blocks = ["A", "^", "<", ">", "v"]
    blocks.permutation(2).each do |combo|
      routes = getDirectionalPadPaths(combo.join, false, false)
      routeLengths = routes.to_h {|k| [k, getDirectionalPadPaths(k).map { |v| getDirectionalPadPaths(v).map(&:length).min }.min]}
      minLength = routeLengths.values.min
      if routeLengths.filter { |k, v| v == minLength }.length > 1
        if combo.join == "vA"
          # <vA>^A - 40. Take >^, vA<^A - 37
          # <vA^>A - 40. Take ^>, <Av>A - 35
          # after manual testing, ^> is slightly better
          routeLengths["<vA>^A"] = routeLengths["<vA>^A"] + 1 #penalty to force the other choice
        else
          raise "Ambigious choice #{combo.join}"
        end
      end
      @buildingBlocks[combo.join] = routeLengths.key(minLength)
    end
  end
  
end