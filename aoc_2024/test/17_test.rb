require 'minitest/autorun'
require 'minitest/pride'
require_relative '../app'

class TestDay17 < Minitest::Test
  def setup
    @day = Day17.new
  end

  def test_part1
    # assert_equal @day.part1(File.read(File.join(APP_ROOT, 'examples', '17_2.txt')).rstrip), "0,1,2"
    # assert_equal @day.part1(File.read(File.join(APP_ROOT, 'examples', '17_3.txt')).rstrip), "4,2,5,6,7,7,7,7,3,1,0"
    # assert_equal @day.part1(File.read(File.join(APP_ROOT, 'examples', '17.txt')).rstrip), "4,6,3,5,6,3,5,2,1,0"
  end

  def test_part2
    assert_equal @day.part2(File.read(File.join(APP_ROOT, 'examples', '17_b.txt')).rstrip), 117440
  end
end