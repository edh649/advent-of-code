require 'minitest/autorun'
require 'minitest/pride'
require_relative '../app'

class TestDay08 < Minitest::Test
  def setup
    @data_a = File.read(File.join(APP_ROOT, 'examples', '08.txt')).rstrip
    @data_b = File
    .read(File.join(APP_ROOT, 'examples', '08.txt')).rstrip
    @day = Day08.new
  end

  # def test_part1
  #   assert_equal @day.part1(@data_a), 14
  # end

  def test_part2
    assert_equal @day.part2(@data_b), 34 
  end
end