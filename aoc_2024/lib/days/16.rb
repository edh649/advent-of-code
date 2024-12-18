
class Day16
    
  def part1(input)
    setupMatrix(input)
    
    @nodeHistory = {}
    pendingNodes = {}
    
    pendingNodes[@start] = 0
    
    score = -1
    finished = false
    while !finished && score < 100000
      score += 1
      pendingNodes.filter {|node, nodeScore| nodeScore == score}.each do |node, nodeScore|
        if node[2] == ">" && @matrix[node[0] + 1][node[1]] == "."
          key = [node[0] + 1, node[1], ">"]
          pendingNodes[key] = [(nodeScore + 1), (pendingNodes[key] || (nodeScore + 1))].min
          @nodeHistory[key] = @nodeHistory.has_key?(key) ? @nodeHistory[key].append([node, score + 1]) : [[node, score + 1]]
        end
        if node[2] == "<" && @matrix[node[0] - 1][node[1]] == "."
          key = [node[0] - 1, node[1], "<"]
          pendingNodes[key] = [(nodeScore + 1), (pendingNodes[key] || (nodeScore + 1))].min
          @nodeHistory[key] = @nodeHistory.has_key?(key) ? @nodeHistory[key].append([node, score + 1]) : [[node, score + 1]]
        end
        if node[2] == "^" && @matrix[node[0]][node[1] + 1] == "."
          key = [node[0], node[1] + 1, "^"]
          pendingNodes[key] = [(nodeScore + 1), (pendingNodes[key] || (nodeScore + 1))].min
          @nodeHistory[key] = @nodeHistory.has_key?(key) ? @nodeHistory[key].append([node, score + 1]) : [[node, score + 1]]
        end
        if node[2] == "v" && @matrix[node[0]][node[1] - 1] == "."
          key = [node[0], node[1] - 1, "v"]
          pendingNodes[key] = [(nodeScore + 1), (pendingNodes[key] || (nodeScore + 1))].min
          @nodeHistory[key] = @nodeHistory.has_key?(key) ? @nodeHistory[key].append([node, score + 1]) : [[node, score + 1]]
        end
        if node[2] == ">" || node[2] == "<"
          key = [node[0], node[1], "^"]
          pendingNodes[key] = [(nodeScore + 1000), (pendingNodes[key] || (nodeScore + 1000))].min
          @nodeHistory[key] = @nodeHistory.has_key?(key) ? @nodeHistory[key].append([node, score + 1000]) : [[node, score + 1000]]
          key = [node[0], node[1], "v"]
          pendingNodes[key] = [(nodeScore + 1000), (pendingNodes[key] || (nodeScore + 1000))].min
          @nodeHistory[key] = @nodeHistory.has_key?(key) ? @nodeHistory[key].append([node, score + 1000]) : [[node, score + 1000]]
        end
        if node[2] == "^" || node[2] == "v"
          key = [node[0], node[1], ">"]
          pendingNodes[key] = [(nodeScore + 1000), (pendingNodes[key] || (nodeScore + 1000))].min
          @nodeHistory[key] = @nodeHistory.has_key?(key) ? @nodeHistory[key].append([node, score + 1000]) : [[node, score + 1000]]
          key = [node[0], node[1], "<"]
          pendingNodes[key] = [(nodeScore + 1000), (pendingNodes[key] || (nodeScore + 1000))].min
          @nodeHistory[key] = @nodeHistory.has_key?(key) ? @nodeHistory[key].append([node, score + 1000]) : [[node, score + 1000]]
        end
        pendingNodes.delete(node)
        
        
        if node[0] == @end[0] && node[1] == @end[1]
          finished = true
        end
      end
    end
    
    if !finished
      puts "reached score limit of #{score}"
      return 0
    end
    puts "step 1 done"
    return score
  end
  
  def part2(input)
    part1(input)
    u = getSmallestRoute(@end[0], @end[1], "^")
    r =getSmallestRoute(@end[0], @end[1], ">")
    l = getSmallestRoute(@end[0], @end[1], "<")
    d = getSmallestRoute(@end[0], @end[1], "v")
    
    steps = []
    u.each { |step| steps.append([step[0], step[1]]) }
    r.each { |step| steps.append([step[0], step[1]]) }
    l.each { |step| steps.append([step[0], step[1]]) }
    d.each { |step| steps.append([step[0], step[1]]) }
    
    steps.uniq!
    return steps.count()
  end
  
  def getSmallestRoute(x, y, direction)
    route = []
    if @nodeHistory[[x, y, direction]] == nil
      return []
    end
    minScore = @nodeHistory[[x, y, direction]].min {|a, b| a[1] <=> b[1]}[1]
    @nodeHistory[[x, y, direction]].filter {|node, score| score == minScore}.each do |node, score|
      if node[0] == @start[0] && node[1] == @start[1]
        route.append([@start[0], @start[1], direction])
      else
        route.append([node[0], node[1], direction])
        route.concat(getSmallestRoute(node[0], node[1], node[2]))
      end
    end
    return route
  end
  
  def setupMatrix(input)
    @matrix = []
    lines = input.split("\n")
    lines.each_with_index.each do |line, row|
      line.chars.each_with_index.each do |char, col|
        y = lines.count() - (row + 1)
        if @matrix[col] == nil
          @matrix[col] = []
        end
        @matrix[col][y] = char
        if char == "S"
          @start = [col, y, ">"]
          @matrix[col][y] = "."
        end
        if char == "E"
          @end = [col, y]
          @matrix[col][y] = "."
        end
      end
    end  
  end
  
end