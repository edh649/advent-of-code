require_relative '../app' #to get day includes

module Aoc2024
  class Runner

    def call(number)
      day = get_day_class(number)
      return unless day

      input_path = File.join(APP_ROOT, 'inputs', "#{number.to_s.rjust(2, '0')}.txt")
      raise 'Input does not exist' unless File.exist?(input_path)

      input_data = File.read(input_path).rstrip

      puts <<~HERE
        Day #{number} #{emoji_for(number)}#{' '}
        - 1: #{day.part1(input_data)}
        - 2: #{day.part2(input_data)}
      HERE
    end

    private

    def get_day_class(number)
      Object.const_get("Day#{number.to_s.rjust(2, '0')}").new
    rescue NameError
      # puts "Day #{number} not implemented"
    end

    def emoji_for(number)
      case number % 3
      when 0
        '🎄'
      when 1
        '❄️'
      when 2
        '🎁'
      end
    end
  end
end