defmodule AdventOfCode.Day03 do
  def part1(input) do
    position = {3, 1, 0, 0, 0}
    countTreeAndKnight(position, input)
  end

  def part2(input) do
    positions = [{1, 1, 0, 0, 0}, {3, 1, 0, 0, 0}, {5, 1, 0, 0, 0}, {7, 1, 0, 0, 0}, {1, 2, 0, 0, 0}]

    Enum.map(positions, &countTreeAndKnight(&1, input))
    |> Enum.reduce(fn x, acc -> x * acc end)
  end

  def parseInput(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&String.to_charlist(&1))
  end

  defp countTreeAndKnight({dx, dy, x, y, count}, input) do
    line = Enum.at(input, y)

    if line == nil do
      count
    else
      case Enum.at(line, rem(x, length(line))) == 35 do
        true -> countTreeAndKnight({dx, dy, x + dx, y + dy, count + 1}, input)
        false -> countTreeAndKnight({dx, dy, x + dx, y + dy, count}, input)
      end
    end
  end
end
