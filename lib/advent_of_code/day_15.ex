defmodule AdventOfCode.Day15 do
  def part1(input) do
    List.last(input)
    |> elem(0)
    |> find(length(input) - 1, 2019, Enum.take(input, length(input) - 1) |> Enum.into(%{}))
  end

  def part2(input) do
    List.last(input)
    |> elem(0)
    |> find(length(input) - 1, 29_999_999, Enum.take(input, length(input) - 1) |> Enum.into(%{}))
  end

  defp find(last, index, target, _) when index == target, do: last

  defp find(last, index, target, map) do
    case Map.get(map, last) do
      nil -> find(0, index + 1, target, Map.put(map, last, index))
      n -> find(index - n, index + 1, target, Map.put(map, last, index))
    end
  end

  def parseInput(input) do
    String.trim(input)
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
  end
end
