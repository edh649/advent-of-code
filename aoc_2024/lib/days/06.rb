
class Day06
  
  def part1(input)
    matrix, pos = setupMatrix(input)
    return runPart1(matrix, pos)
  end
    
  def runPart1(matrix, pos)
    direction = 1
    
    i = 0
    sameHash = 0
    while sameHash < 500 && i < 50000 #arbitarily large #s
      i += 1
      if i % 100 == 0
        puts "iteration: " + i.to_s
      end
      matrix, pos, direction, changed = progressMatrix(matrix, pos, direction)
      changed ? sameHash += 1 : sameHash = 0
    end
    
    puts "same hash @ iteration " + i.to_s
    
    return matrix.flatten.count("X")
    
  end
  
  def setupMatrix(input)
    matrix = []
    start = []
    lines = input.split("\n")
    lines.each_with_index.each do |line, row|
      line.chars.each_with_index.each do |char, col|
        y = lines.count() - (row + 1)
        if matrix[col] == nil
          matrix[col] = []
        end
        matrix[col][y] = char
        if char == "^"
          start = [col, y]
          matrix[col][y] = "X"
        end
      end
    end
    
    return matrix, start
  end
  
  def progressMatrix(matrix, oldpos, direction)
    changed = true
    boundX = matrix.count() - 1
    boundY = matrix[0].count() - 1
    
    if direction == 1 #up
      pos = [oldpos[0], oldpos[1] + 1]
    end
    if direction == 2 #r
      pos = [oldpos[0] + 1, oldpos[1]]
    end
    if direction == 3 #d
      pos = [oldpos[0], oldpos[1] - 1]
    end
    if direction == 4 #l
      pos = [oldpos[0] - 1, oldpos[1]]
    end
    
    if matrix[pos[0]][pos[1]] == "#"
      direction += 1
      if direction == 5
        direction = 1
      end
      pos = oldpos
      changed = false
    end
    
    if pos[0] < 0 || pos[0] > boundX || pos[1] < 0 || pos[1] > boundY
      pos = oldpos
      changed = false
    end
    
    #update matrix
    matrix[pos[0]][pos[1]] = "X"
    
    return matrix, pos, direction, changed
  end
  
  def part2(input)
    matrix, pos = setupMatrix(input)
    #brute force it here?
  end
  
end