
class Day10
    
  def part1(input)
    @matrix = setupMatrix(input)
    
    scores = []
    for x in 0..@matrix.count() - 1
      for y in 0..@matrix[0].count() - 1
        if @matrix[x][y] == '0'
          scores.append(computeTrailheadScore(x, y, @matrix))
        end
      end
    end
  end
  
  def computeTrailheadScore(x, y)
    possibleRoutes = []
    # try all directions for remaining valid routes
  end
  
  def routeIsValid?(x, y, route)
    # check increases by 1 for each route
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
  
  def part2(input)
   
  end
  
end