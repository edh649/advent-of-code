
class Day08
  
  
  def part1(input)
    matrix = setupMatrix(input)
    
    antinodeLocations = []
    for x in 0..matrix.count() - 1
      for y in 0..matrix[0].count() - 1
        getAntinodeLocationsFor(x, y, matrix).each do |x, y|
          puts "\n antinode @ " + x.to_s + ", " + y.to_s + "\n"
          antinodeLocations.append([x, y])
        end
      end
    end
    antinodeLocations.uniq!
    printMatrixWithAntinodes(matrix, antinodeLocations)
    return antinodeLocations.count()
  end
  
  def getAntinodeLocationsFor(x, y, matrix)
    node = matrix[x][y]
    if node == "."
      return []
    end
    locations = []
    for x1 in 0..matrix.count() - 1
      for y1 in 0..matrix[0].count() - 1
        if (x == x1 && y == y1)
          next
        end
        if matrix[x1][y1] == node
          getAntinodeLocations(x, y, x1, y1, matrix).each do |x, y|
            locations.append([x, y])
          end
        end
      end
    end
    return locations
  end
  
  def getAntinodeLocations(x1, y1, x2, y2, matrix)
    deltaY = y2 - y1 #503 - 500 = 3
    deltaX = x2 - x1 # 202 - 200 = 2
    
    locations = [
      [x1 - deltaX, y1 - deltaY],
      [x2 + deltaX, y2 + deltaY]
    ]
    
    locations.reject! do |x, y|
      x < 0 || y < 0 || x >= matrix.count() || y >= matrix[0].count()
    end
    
    return locations
  end
  
  def setupMatrix(input)
    matrix = []
    lines = input.split("\n")
    lines.each_with_index.each do |line, row|
      line.chars.each_with_index.each do |char, col|
        y = lines.count() - (row + 1)
        if matrix[col] == nil
          matrix[col] = []
        end
        matrix[col][y] = char
      end
    end
    
    return matrix
  end
  
  def printMatrixWithAntinodes(matrix, antinodes)
    puts "\n\n"
    for nY in 1..matrix[0].count()
      y = matrix[0].count()-nY
      for x in 0..matrix.count() - 1
        if matrix[x][y] == '.' && antinodes.include?([x, y])
          print("#")
        else
          print(matrix[x][y])
        end
      end
      puts "\n"
    end
    puts "\n\n"
  end
  
  def part2(input) ##1199 too low
    matrix = setupMatrix(input)
    
    antinodeLocations = []
    for x in 0..matrix.count() - 1
      for y in 0..matrix[0].count() - 1
        getAntinodeLocationsFor2(x, y, matrix).each do |x, y|
          puts "\n antinode @ " + x.to_s + ", " + y.to_s + "\n"
          antinodeLocations.append([x, y])
        end
      end
    end
    antinodeLocations.uniq!
    printMatrixWithAntinodes(matrix, antinodeLocations)
    return antinodeLocations.count()
  end
  
  def getAntinodeLocationsFor2(x, y, matrix)
    node = matrix[x][y]
    if node == "."
      return []
    end
    locations = []
    for x1 in 0..matrix.count() - 1
      for y1 in 0..matrix[0].count() - 1
        if (x == x1 && y == y1)
          next
        end
        if matrix[x1][y1] == node
          getAntinodeLocations2(x, y, x1, y1, matrix).each do |x, y|
            locations.append([x, y])
          end
        end
      end
    end
    return locations
  end
  
  def getAntinodeLocations2(x1, y1, x2, y2, matrix)
    deltaY = (y2 - y1).to_f #503 - 500 = 3
    deltaX = (x2 - x1).to_f # 202 - 200 = 2
    #y = mx + c
    m = deltaY.fdiv(deltaX)
    c = y1 - m * x1
    
    locations = []
    for x in 0..matrix.count() - 1
      y = (m * x) + c
      if y.floor() != y #not working
        next
      end
      if y < 0 || y >= matrix[0].count()
        next
      end
      locations.append([x, y.floor()])
    end
    
    return locations
  end
  
end