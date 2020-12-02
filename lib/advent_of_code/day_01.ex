defmodule AdventOfCode.Day01 do
  def part1(input) do
    {first, second} = find2020(input, 2020)
    first * second
  end

  def part2(input) do
    {first, second, third} = findThree2020(input)
    first * second * third
  end

  def parseInput(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.map(&Integer.parse(&1))
    |> Enum.map(&elem(&1, 0))
  end

  defp findThree2020([head | tail]) do
    others = find2020(tail, 2020 - head)

    case others do
      nil -> findThree2020(tail)
      _ -> {head, elem(others, 0), elem(others, 1)}
    end
  end

  defp find2020([], _target) do
    nil
  end

  defp find2020([first | tail], target) do
    second = Enum.find(tail, &(first + &1 == target))

    case second do
      nil -> find2020(tail, target)
      _ -> {first, second}
    end
  end
end
