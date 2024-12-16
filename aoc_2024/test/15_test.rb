require 'minitest/autorun'
require 'minitest/pride'
require_relative '../app'

class TestDay15 < Minitest::Test
  def setup
    @day = Day15.new
  end

  def test_part1
    assert_equal @day.part1(File.read(File.join(APP_ROOT, 'examples', '15_gps.txt')).rstrip), 104
    assert_equal @day.part1(File.read(File.join(APP_ROOT, 'examples', '15_large.txt')).rstrip), 10092
    assert_equal @day.part1(File.read(File.join(APP_ROOT, 'examples', '15_small.txt')).rstrip), 2028
  end

  def test_part2
    assert_equal @day.part2(File.read(File.join(APP_ROOT, 'examples', '15_large.txt')).rstrip), 9021
  end
end