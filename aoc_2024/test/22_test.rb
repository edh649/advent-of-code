require 'minitest/autorun'
require 'minitest/pride'
require_relative '../app'

class TestDay22 < Minitest::Test
  def setup
    @day = Day22.new
  end

  def test_part1
    # assert_equal @day.part1(File.read(File.join(APP_ROOT, 'examples', '22.txt')).rstrip), 37327623
  end

  def test_part2
    assert_equal @day.part2(File.read(File.join(APP_ROOT, 'examples', '22_2.txt')).rstrip), 23
  end
end