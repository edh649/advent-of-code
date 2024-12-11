
class Day09
    
  def part1(input) #6323641412437
    fileList = generateFileList(input)
    
    i = 0
    fileList.map! do |file|
      i+=1
      if i == fileList.length && file == nil
        break #at the end, don't do any silly swapping
      elsif file == nil
        fileProposed = nil
        while fileProposed == nil
          fileProposed = fileList.pop
        end
        file = fileProposed
      end
      file
    end
    
    if fileList[-1] == nil #remove trailing nil if present
      fileList.pop
    end
    
    result = fileList.each_with_index.sum {|i, file| i * file }
    return result
  end
  
  def generateFileList(input)
    fileList = []
    file = true
    fileIndex = 0
    index = 0
    input.chars.each do |char|
      toRecord = nil
      if file == true
        toRecord = fileIndex
        fileIndex += 1
        file = false
      else 
        file = true
      end
      for n in 0..(char.to_i - 1)
        fileList[index + n] = toRecord
      end
      index += char.to_i
    end
    return fileList
  end
  
  def part2(input)
   
  end
  
end