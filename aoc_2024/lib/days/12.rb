
class Day12
    
  def part1(input)
    @matrix = setupMatrixBounded(input)
    @unassignedMatrix = setupMatrixBounded(input)
    
    regions = []
    for x in 1..@matrix.count() - 2
      for y in 1..@matrix.count() - 2
        if @unassignedMatrix[x][y] != nil
          region = [[x, y]]
          @unassignedMatrix[x][y] = nil
          while expandRegion?(region) 
          end
          regions.push(region)
        end
      end
    end
    
    price = regions.map { |region| findRegionPermiter(region) * region.count() }
    
    return price.sum()
  end
  
  def expandRegion?(region)
    changed = false
    region.each do |point|
      #check if any surrounding points are in region
      value = @matrix[point[0]][point[1]]
      for x in -1..1
        for y in -1..1
          if x == y || x == -y
            next # skip diagonals
          end
          if @unassignedMatrix[point[0] + x][point[1] + y] == value
            @unassignedMatrix[point[0] + x][point[1] + y] = nil
            region.push([point[0] + x, point[1] + y])
            changed = true
          end
        end
      end
    end    
    return changed
  end
  
  def findRegionPermiter(region)
    perimiters = []
    regionValue = @matrix[region[0][0]][region[0][1]]
    region.each do |point|
      for x in -1..1
        for y in -1..1
          if x == y || x == -y
            next # skip diagonals
          end
          if @matrix[point[0] + x][point[1] + y] != regionValue
            perimiters.push([point[0] + x, point[1] + y])
          end
        end
      end
    end
    # puts "perimiter for region #{regionValue} is #{perimiters.count()}"
    return perimiters.count()
  end
  
  def part2(input)
    @matrix = setupMatrixBounded(input)
    @unassignedMatrix = setupMatrixBounded(input)
    
    regions = []
    for x in 1..@matrix.count() - 2
      for y in 1..@matrix.count() - 2
        if @unassignedMatrix[x][y] != nil
          region = [[x, y]]
          @unassignedMatrix[x][y] = nil
          while expandRegion?(region) 
          end
          regions.push(region)
        end
      end
    end
    
    price = regions.map { |region| findRegionCorners(region) * region.count() }
    
    return price.sum()
  end
  
  def findRegionCorners(region)
    corners = 0
    regionValue = @matrix[region[0][0]][region[0][1]]
    region.each do |point|
      corners += countPointCorners(point[0], point[1], regionValue)
    end
    return corners
  end
  
  def countPointCorners(x, y, regionValue)
    corners = 0
    #external corners
    if @matrix[x + 1][y] != regionValue && @matrix[x][y + 1] != regionValue
      corners +=1 
    end
    if @matrix[x - 1][y] != regionValue && @matrix[x][y + 1] != regionValue
      corners +=1 
    end
    if @matrix[x + 1][y] != regionValue && @matrix[x][y - 1] != regionValue
      corners +=1 
    end
    if @matrix[x - 1][y] != regionValue && @matrix[x][y - 1] != regionValue
      corners +=1 
    end
    
    #internal corners
    if @matrix[x + 1][y] == regionValue && @matrix[x][y + 1] == regionValue && @matrix[x + 1][y + 1] != regionValue
      corners +=1 
    end
    if @matrix[x + 1][y] == regionValue && @matrix[x][y - 1] == regionValue && @matrix[x + 1][y - 1] != regionValue
      corners +=1 
    end
    if @matrix[x - 1][y] == regionValue && @matrix[x][y + 1] == regionValue && @matrix[x - 1][y + 1] != regionValue
      corners +=1 
    end
    if @matrix[x - 1][y] == regionValue && @matrix[x][y - 1] == regionValue && @matrix[x - 1][y - 1] != regionValue
      corners +=1 
    end
    return corners
  end
  
  def setupMatrixBounded(input)
    matrix = []
    lines = input.split("\n")
    lines.each_with_index.each do |line, row|
      line.chars.each_with_index.each do |char, col|
        y = lines.count() - (row + 1)
        if matrix[col+1] == nil
          matrix[col+1] = []
        end
        matrix[col+1][y+1] = char
      end
    end
    
    len = matrix.count()
    matrix[len] = []
    matrix[0] = []
    for i in 0..(matrix.count() - 1)
      matrix[0][i] = nil
      matrix[i][0] = nil
      matrix[len][i] = nil
      matrix[i][len] = nil
    end
    
    return matrix
  end
  
end