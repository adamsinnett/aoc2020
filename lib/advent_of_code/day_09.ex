defmodule AdventOfCode.Day09 do
  def part1(input) do
    find(Enum.take(input, 25), Enum.drop(input, 25))
  end

  def part2(input) do
    findRange([], input, part1(input))
  end

  def parseInput(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&String.to_integer(&1))
  end

  # part 2
  defp findRange(range, [hd | tail], target) do
    if sum > target do
      findRange(tl(range), [hd | tail], target)
    else
      case sum do
        x when x == target ->
          hd(range) + List.last(range)

        x when x < target ->
          findRange(range ++ [hd], tail, target)

        x when x > target ->
          findRange(tl(range) ++ [hd], tail, target)
      end
    end
  end

  defp findRange(range, [], target) do
    IO.puts("oops")
  end

  # part 1
  defp find(preamble, [head | tail]) do
    case has25?(head, preamble) do
      true -> find(preamble ++ [head], tail)
      false -> head
    end
  end

  defp has25?(target, [hd | tail]) do
    case Enum.member?(tail, target - hd) do
      true -> true
      false -> has25?(target, tail)
    end
  end

  defp has25?(_, []) do
    false
  end
end
