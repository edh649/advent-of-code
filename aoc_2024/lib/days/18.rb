
class Day18
    
  def part1(input, size = 70, dropIterations = 1024)
    setup(input, size)
    
    for i in 1..dropIterations
      drop = @incoming.shift
      @matrix[drop[0]][drop[1]] = "#"
    end
    
    pendingNodes = {}
    pendingNodes[@start] = 0
    step = -1
    finished = false
    while !finished && step < 1000 # 1000 is arbitrary, but seems to do!
      step += 1
      nextNodes = {}
      
      pendingNodes.each do |node, val|
        nextNodes[[node[0] + 1, node[1]]] = 0 if @matrix.count() > node[0] + 1 && @matrix[node[0] + 1][node[1]] == "."
        nextNodes[[node[0] - 1, node[1]]] = 0 if node[0] - 1 >= 0 && @matrix[node[0] - 1][node[1]] == "."
        nextNodes[[node[0], node[1] + 1]] = 0 if @matrix[node[0]].count() > node[1] + 1 && @matrix[node[0]][node[1] + 1] == "."
        nextNodes[[node[0], node[1] - 1]] = 0 if node[1] - 1 >= 0 && @matrix[node[0]][node[1] - 1] == "."
        
        if node[0] == @end[0] && node[1] == @end[1]
          finished = true
        end
      end
      
      pendingNodes.clear
      pendingNodes = nextNodes.dup
    end
    
    if !finished
      puts "reached step limit of #{step}"
      return nil
    end
    # puts "step 1 done"
    return step
  end 
  
  def printMatrix(pendingNodes = [])
    for x in 0..(@matrix.count() - 1)
      line = "\n"
      for y in 0..(@matrix[0].count() - 1)
        if pendingNodes.include?([x, y])
          line += "?"          
        else
          line += @matrix[x][y]
        end
      end
      puts line
    end
  end
  
  
  def setup(input, size)
    @matrix = []
    for x in 0..size
      @matrix[x] = []
      for y in 0..size
        @matrix[x][y] = "."
      end
    end
    @start = [0, 0]
    @end = [size, size]
    @incoming = input.split("\n").map { |row| row.split(",").map(&:to_i) }
  end  
  
  def part2(input, size = 70)
    #search blocked first roughly, then unblock precise back up
    blocked = true
    i = input.split("\n").count()
    while blocked
      i -= 10
      if part1(input, size, i) != nil
        blocked = false
      end
    end
    puts "unblocked at #{i}"
    blocked = false
    while !blocked
      i +=1
      if i % 10 == 0
        puts i.to_s + "\n"
      end
      if part1(input, size, i) == nil
        puts "blocked at #{i}"
        blocked = true
      end
    end
    return input.split("\n")[i-1]
  end
  
end