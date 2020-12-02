defmodule AdventOfCode.Day02 do
  def part1(input) do
    Enum.filter(input, &passwordIsValid(&1))
    |> length()
  end

  def part2(input) do
    Enum.filter(input, &passwordIsValidTwo(&1))
    |> length()
  end

  def parseInput(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
  end

  defp passwordIsValidTwo([range, rule, password]) do
    letter = String.first(rule) |> to_charlist() |> List.first()
    first = String.split(range, "-") |> List.first() |> Integer.parse() |> elem(0)
    second = String.split(range, "-") |> List.last() |> Integer.parse() |> elem(0)
    list = to_charlist(password)

    (Enum.at(list, first - 1) == letter and Enum.at(list, second - 1) !== letter) or
      (Enum.at(list, first - 1) != letter and Enum.at(list, second - 1) !== letter)
  end

  defp passwordIsValid([range, rule, password]) do
    letter = String.first(rule) |> to_charlist() |> List.first()

    to_charlist(password)
    |> Enum.filter(fn ch -> ch == letter end)
    |> length()
    |> inRange?(range)
  end

  defp inRange?(length, range) do
    min = String.split(range, "-") |> List.first() |> Integer.parse() |> elem(0)
    max = String.split(range, "-") |> List.last() |> Integer.parse() |> elem(0)

    length >= min and length <= max
  end
end
