defmodule AdventOfCode.Day02 do
  def part1(_input) do
  end

  def part2(_input) do
  end

  def parseInput(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.map(&Integer.parse(&1))
    |> Enum.map(&elem(&1, 0))
  end
end
