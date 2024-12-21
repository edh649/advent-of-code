require 'minitest/autorun'
require 'minitest/pride'
require_relative '../app'

class TestDay21 < Minitest::Test
  def setup
    @day = Day21.new
  end

  def test_part1
    # assert_equal @day.part1(File.read(File.join(APP_ROOT, 'examples', '21.txt')).rstrip), 126384
  end

  def test_part2
    assert_equal @day.part2(File.read(File.join(APP_ROOT, 'examples', '21.txt')).rstrip), 285
  end
end