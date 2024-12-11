
class Day10
    
  def part1(input)
    @matrix = setupMatrix(input)
    
    scores = []
    for x in 0..@matrix.count() - 1
      for y in 0..@matrix[0].count() - 1
        if @matrix[x][y] == '0'
          scores.append(computeTrailheadScore(x, y))
        end
      end
    end
    return scores.sum
  end
  
  def computeTrailheadScore(x, y)
    trailEnds = []
    possibleRoutes = [[0], [1], [2], [3]]
    # try all directions for remaining valid routes
    while possibleRoutes != []
      routeToCheck = possibleRoutes.shift()
      [0, 1, 2, 3].each do |direction|
        newRoute = routeToCheck.dup.append(direction)
        routeEnd = getRouteEnd(x, y, newRoute)
        if routeEnd != nil
          possibleRoutes.append(newRoute)
          if newRoute.count == 9
            trailEnds.append(routeEnd)
          end
        end
      end
    end
    if trailEnds == []
      return 0
    end
    return trailEnds.uniq.count()
  end
  
  def getRouteEnd(x, y, route)
    # check increases by 1 for each route
    for i in 0..route.count() - 1
      if route[i] == 0
        y += 1
      elsif route[i] == 1
        x += 1
      elsif route[i] == 2
        y -= 1
      elsif route[i] == 3
        x -= 1
      end
      
      if x < 0 || y < 0
        return nil
      end
      
      #check if out of bounds
      if @matrix[x] == nil || @matrix[x][y] == nil
        return nil
      end
      if @matrix[x][y] != (i + 1).to_s
        return nil
      end
    end
    return [x, y]
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
    @matrix = setupMatrix(input)
    
    scores = []
    for x in 0..@matrix.count() - 1
      for y in 0..@matrix[0].count() - 1
        if @matrix[x][y] == '0'
          scores.append(computeTrailheadScore2(x, y))
        end
      end
    end
    return scores.sum
  end
  
  def computeTrailheadScore2(x, y)
    trailEnds = []
    possibleRoutes = [[0], [1], [2], [3]]
    # try all directions for remaining valid routes
    while possibleRoutes != []
      routeToCheck = possibleRoutes.shift()
      [0, 1, 2, 3].each do |direction|
        newRoute = routeToCheck.dup.append(direction)
        routeEnd = getRouteEnd(x, y, newRoute)
        if routeEnd != nil
          possibleRoutes.append(newRoute)
          if newRoute.count == 9
            trailEnds.append(routeEnd)
          end
        end
      end
    end
    if trailEnds == []
      return 0
    end
    return trailEnds.count()
  end
  
end