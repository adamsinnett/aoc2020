defmodule AdventOfCode.Day02 do
  def part1(input) do
    Enum.count(input, &passwordIsValid(&1))
  end

  def part2(input) do
    Enum.count(input, &passwordIsValidTwo(&1))
  end

  def parseInput(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(&normalizeInput(&1))
  end

  defp normalizeInput([range, rule, password]) do
    [min, max] = String.split(range, "-", trim: true)

    [
      String.to_integer(min),
      String.to_integer(max),
      rule |> to_charlist() |> List.first(),
      to_charlist(password)
    ]
  end

  defp passwordIsValidTwo([min, max, letter, password]) do
    Enum.at(password, min - 1) == letter !==
      (Enum.at(password, max - 1) == letter)
  end

  defp passwordIsValid([min, max, rule, password]) do
    count =
      to_charlist(password)
      |> Enum.count(fn ch -> ch == rule end)

    count >= min and count <= max
  end
end
