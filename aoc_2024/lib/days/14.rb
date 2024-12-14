
class Day14
    
  def part1(input, width=101, height=103)
    robots = input.split("\n").map do |line|
      start = line.split(" ")[0].split("=")[1].split(",")
      velocity = line.split(" ")[1].split("=")[1].split(",")
      robot = Robot.new([start[0].to_i, start[1].to_i], [velocity[0].to_i, velocity[1].to_i])
      robot
    end
    
    robots.each do |robot|
      robot.iterate!(100) #100 seconds
      robot.wrap!(width, height)
    end
    
    quadrants = [0, 0, 0, 0]
    robots.each do |robot|
      if robot.pos[0] < width/2 && robot.pos[1] < height/2
        quadrants[0] += 1
      elsif robot.pos[0] > width/2 && robot.pos[1] < height/2
        quadrants[1] += 1
      elsif robot.pos[0] < width/2 && robot.pos[1] > height/2
        quadrants[2] += 1
      elsif robot.pos[0] > width/2 && robot.pos[1] > height/2
        quadrants[3] += 1
      end
    end
    
    quadrants.inject(:*)
  end
  
  def part2(input, width=101, height=103) #iterate through until you see the tree
    robots = input.split("\n").map do |line|
      start = line.split(" ")[0].split("=")[1].split(",")
      velocity = line.split(" ")[1].split("=")[1].split(",")
      robot = Robot.new([start[0].to_i, start[1].to_i], [velocity[0].to_i, velocity[1].to_i])
      robot
    end
    
    n = 0
    while n < 10000
      n += 1
      robots.each do |robot|
        robot.iterate!(1)
        robot.wrap!(width, height)
      end
      positions = {}
      robots.each { |robot| positions[robot.pos[0] * 1000 + robot.pos[1]] = 1}
      validity = 0
      robots.each do |robot|
        for i in 1..5
          if !positions.has_key?(robot.pos[0] * 1000 + (robot.pos[1] + i))
            break
          end
          if i == 5
            validity += 1
          end
        end
        for i in 1..5
          if !positions.has_key?((robot.pos[0] + i) * 1000 + robot.pos[1])
            break
          end
          if i == 5
            validity += 1
          end
        end
      end
      if validity >= 2
        printPositions(robots, width, height)
        puts n
      end
    end
    puts "not found after #{n} iterations"
  end
  
  def printPositions(robots, width, height)
    positions = robots.map { |robot| robot.pos }
    for y in 0..height
      line = "\n"
      for x in 0..width
        if positions.include?([x, y])
          line += "#"
        else
          line += "."
        end
      end
      puts line
    end
  end
  
  class Robot
    attr_accessor :start_pos, :velocity, :pos
    
    def initialize(start_pos, velocity)
      @start_pos = start_pos
      @velocity = velocity
      @pos = @start_pos
    end
    
    def iterate!(n)
      @pos[0] += (n * @velocity[0])
      @pos[1] += (n * @velocity[1])
    end
    
    def wrap!(xMax, yMax)
      @pos[0] = @pos[0] % xMax
      @pos[1] = @pos[1] % yMax
    end
  end
end