require 'minitest/autorun'
require 'minitest/pride'
require_relative '../app'

class TestDay18 < Minitest::Test
  def setup
    @day = Day18.new
  end

  def test_part1
    assert_equal @day.part1(File.read(File.join(APP_ROOT, 'examples', '18.txt')).rstrip, 6, 12), 22  
  end

  def test_part2
    assert_equal @day.part2(File.read(File.join(APP_ROOT, 'examples', '18.txt')).rstrip, 6), '6,1'
  end
end