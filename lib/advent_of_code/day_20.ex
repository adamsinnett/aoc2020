defmodule AdventOfCode.Day20 do
  def part1(_input) do
  end

  def part2(_input) do
  end

  def parseInput(input) do
    String.split(input, "\n\n", trim: true)
    |> Enum.map(&parseTile/1)
    |> IO.inspect()
  end

  defp parseTile("Tile " <> tile) do
    [num, interior] = String.split(tile, ":")
    {num, String.split(interior, "\n")}
  end
end
