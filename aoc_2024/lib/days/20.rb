
class Day20
    
  def part1(input, savesAtLeast = 100) #1364 too low
    return part2(input, savesAtLeast, 2) #just use pt 2 as it's much much quicker
    setupMatrixBounded(input)
    shortest, possibleShortcuts = findShortestPath(true)
    puts "Shortest base path: #{shortest}"
    
    shortcutResults = {}
    i = 0
    possibleShortcuts.uniq.each do |shortcut|
      i += 1
      if i % 100 == 0
        puts "analyzed #{i} shortcuts of #{possibleShortcuts.count()} \n"
      end
      @matrix[shortcut[0]][shortcut[1]] = "."
      shortcutResults[shortcut], _ = findShortestPath()
      @matrix[shortcut[0]][shortcut[1]] = "#"
    end
    
    puts "analyzed shortcuts"
       
    scoreThreshold = shortest - savesAtLeast
    possibleShortcuts.filter! { |shortcut| shortcutResults[shortcut] <= scoreThreshold }
    
    return possibleShortcuts.count()
  end
  
  def findShortestPath(findShortcuts = false)
    nextSteps = [@start.dup]
    possibleShortcuts = []
    foundEnd = false
    i = 0
    while !foundEnd
      i += 1
      if i > 10000
        raise "Too many iterations"
      end
      steps = nextSteps.dup().uniq
      nextSteps = []
      steps.each do |step|
        if [step[0], step[1]] == @end
          foundEnd = true
          break
        end
        @matrix[step[0]][step[1]] = i
        
        nextSteps.push([step[0] + 1, step[1]]) if @matrix[step[0] + 1][step[1]] == "."
        nextSteps.push([step[0] - 1, step[1]]) if @matrix[step[0] - 1][step[1]] == "."
        nextSteps.push([step[0], step[1] + 1]) if @matrix[step[0]][step[1] + 1] == "."
        nextSteps.push([step[0], step[1] - 1]) if @matrix[step[0]][step[1] - 1] == "."
        
        if findShortcuts
          possibleShortcuts.push([step[0] + 1, step[1]]) if @matrix[step[0] + 1][step[1]] == "#" && @matrix[step[0] + 2][step[1]] == "."
          possibleShortcuts.push([step[0] - 1, step[1]]) if @matrix[step[0] - 1][step[1]] == "#" && @matrix[step[0] - 2][step[1]] == "."
          possibleShortcuts.push([step[0], step[1] + 1]) if @matrix[step[0]][step[1] + 1] == "#" && @matrix[step[0]][step[1] + 2] == "."
          possibleShortcuts.push([step[0], step[1] - 1]) if @matrix[step[0]][step[1] - 1] == "#" && @matrix[step[0]][step[1] - 2] == "."
        end
      end
    end
    
    @matrix.map! { |row| row.map { |cell| cell.is_a?(Integer) ? "." : cell } }
    
    return (i - 1), possibleShortcuts
  end
  
  
  def setupMatrixBounded(input)
    @matrix = [[]]
    lines = input.split("\n")
    lines.each_with_index.each do |line, row|
      line.chars.each_with_index.each do |char, col|
        y = lines.count() - (row + 1)
        if @matrix[col+1] == nil
          @matrix[col+1] = []
        end
        @matrix[col+1][y] = char
        if char == "S" # start
          @start = [col+1, y]
          @matrix[col+1][y] = "."
        elsif char == "E" # end
          @end = [col+1, y]
          @matrix[col+1][y] = "."
        end
      end
    end
    
    len = @matrix.count()
    @matrix[len] = []
    @matrix[0] = []
    for i in 0..(@matrix.count() - 1)
      @matrix[0][i] = "#"
      @matrix[i][0] = "#"
      @matrix[len][i] = "#"
      @matrix[i][len - 1] = "#"
    end
  end

  
  def part2(input, savesAtLeast = 100, cheatLimit = 20)
    # from end, calculate distance from every square.
    # then from start, calculate distance to every square.
    # for each (valid) square, find smaller squares within 20 squares
    setupMatrixBounded(input)
    distFromStartMatrix = fillWithDistanceFrom(@start, @matrix.map { |row| row.dup }.dup)
    distFromEndMatrix = fillWithDistanceFrom(@end, @matrix.map { |row| row.dup }.dup)
    
    standardTime = distFromStartMatrix[@end[0]][@end[1]]
      
    shortcuts = 0
    for x in 0.upto(@matrix.count() - 1)
      for y in 0.upto(@matrix.count() - 1)
        shortcuts += findShortcutsFromPosition([x, y], distFromStartMatrix, distFromEndMatrix, cheatLimit, standardTime - savesAtLeast).count
      end
    end
    return shortcuts
  end
  
  def findShortcutsFromPosition(position, distFromStartMatrix, distFromEndMatrix, maxDist = 20, timeToBeat)
    shortcuts = {}
    return shortcuts unless distFromStartMatrix[position[0]][position[1]].is_a?(Integer)
    posDistanceFromStart = distFromStartMatrix[position[0]][position[1]]
    for x in (-maxDist).upto(maxDist)
      for y in (-maxDist).upto(maxDist)
        timeSpent = x.abs + y.abs
        next if timeSpent > maxDist || timeSpent < -maxDist ## within the dist
        next if timeSpent == 1 || timeSpent == -1 ## not just a normal step
        next if x == 0 && y == 0 # not the same square
        next if position[0] + x < 0 || position[1] + y < 0 || position[0] + x >= @matrix.count() || position[1] + y >= @matrix.count() # not out of bounds
        
        if distFromEndMatrix[position[0] + x][position[1] + y].is_a?(Integer) && distFromEndMatrix[position[0] + x][position[1] + y].is_a?(Integer)
          newTime = posDistanceFromStart + distFromEndMatrix[position[0] + x][position[1] + y] + timeSpent
          next if newTime > timeToBeat
          shortcuts[[position[0] + x, position[1] + y]] = newTime unless shortcuts[[position[0] + x, position[1] + y]] && shortcuts[[position[0] + x, position[1] + y]] < newTime
        end
      end
    end
    return shortcuts
  end
  
  def fillWithDistanceFrom(position, matrix)
    nextSteps = [position.dup]
    i = -1
    while nextSteps != []
      i += 1
      if i > 10000
        raise "Too many iterations"
      end
      steps = nextSteps.dup().uniq
      nextSteps = []
      steps.each do |step|
        matrix[step[0]][step[1]] = i
        
        nextSteps.push([step[0] + 1, step[1]]) if matrix[step[0] + 1][step[1]] == "."
        nextSteps.push([step[0] - 1, step[1]]) if matrix[step[0] - 1][step[1]] == "."
        nextSteps.push([step[0], step[1] + 1]) if matrix[step[0]][step[1] + 1] == "."
        nextSteps.push([step[0], step[1] - 1]) if matrix[step[0]][step[1] - 1] == "."
      end
    end
    
    return matrix
  end
  
end