
class Day06
    
  def part1(input)
    matrix, pos = setupMatrix(input)
    direction = 1
    
    prevHash = nil
    i = 0
    sameHash = 0
    while sameHash < 100 && i < 50000 #arbitarily large #s
      i += 1
      if i % 100 == 0
        puts "iteration: " + i.to_s
      end
      prevHash == matrix.hash ? sameHash += 1 : sameHash = 0
      prevHash = matrix.hash
      matrix, pos, direction = progressMatrix(matrix, pos, direction)
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
    end
    
    if pos[0] < 0 || pos[0] > boundX || pos[1] < 0 || pos[1] > boundY
      pos = oldpos
    end
    
    #update matrix
    matrix[pos[0]][pos[1]] = "X"
    
    return matrix, pos, direction
  end
  
  def part2(input)
    matrix, pos = setupMatrix(input)
    matrix[pos[0]][pos[1]] = [1] # record direction
    direction = 1
    
    prevHash = nil
    i = 0
    sameHash = 0
    while sameHash < 100 && i < 50000 #arbitarily large #s
      i += 1
      if i % 100 == 0
        puts "iteration: " + i.to_s + "\n"
      end
      prevHash == matrix.hash ? sameHash += 1 : sameHash = 0
      prevHash = matrix.hash
      matrix, pos, direction = progressMatrix2(i, matrix, pos, direction)
    end
    
    puts "same hash @ iteration " + i.to_s + "\n\n"
    
    # find all places which have been visited twice and are 90degrees off
    for x in 0..matrix.count() - 1
      for y in 0..matrix[0].count() - 1
        matrixValue = matrix[x][y]
        if !matrixValue.is_a?(Hash) || matrixValue.count() < 2
          next
        end
        
        prevPos = nil
        matrixValue.each do |i, pos|
          if prevPos == nil
            prevPos = pos
            next
          end
          blocker = nil
          # get position of blocker
          if pos == 1 && prevPos == 2 # is going up and needs to go right (2) for loop
            blocker = [x, y + 1]
          elsif pos == 2 && prevPos == 3 # is going right and needs to go down (3) for loop
            blocker = [x + 1, y]
          elsif pos == 3 && prevPos == 4 # is going down and needs to go left (4) for loop
            blocker = [x, y - 1]
          elsif pos == 4 && prevPos == 1 # is going left and needs to go up (1) for loop
            blocker = [x - 1, y]
          end
          
          if blocker == nil
            next
          end
          
          #get matrixValue of blocker
          blockerMatrixValue = matrix[blocker[0]][blocker[1]]
          
          if blockerMatrixValue.is_a?(Hash)
            invalid = false
            blockerMatrixValue.each do |blockerI, pos|
              if blockerI < i
                invalid = true
                break
              end
            end
            if invalid
              next # try next blocker
            end
          end
          
          puts "\n"
          puts blocker[0].to_s + ", " + blocker[1].to_s
        end
        
        if matrixValue.count() >= 4
          puts "can't handle > 4 crosses"
        end
      end
    end
    
  end
  
  
  def progressMatrix2(i, matrix, oldpos, direction)
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
    end
    
    if pos[0] < 0 || pos[0] > boundX || pos[1] < 0 || pos[1] > boundY
      pos = oldpos
      return matrix, pos, direction
    end
    
    #update matrix
    if matrix[pos[0]][pos[1]] == "."
      matrix[pos[0]][pos[1]] = {}
    end
    matrix[pos[0]][pos[1]][i] = direction
    matrix[pos[0]][pos[1]]
    
    return matrix, pos, direction
  end
  
end