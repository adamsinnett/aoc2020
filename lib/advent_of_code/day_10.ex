defmodule AdventOfCode.Day10 do
  use Agent

  def part1(input) do
    countIncrements(input, {0, 0})
    |> (fn {one, three} -> one * three end).()
  end

  def part2(input) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)

    (countPermutations(hd(input), tl(input)) / 2)
    |> round
  end

  defp countPermutations(_, []), do: 1

  defp countPermutations(curr, [hd | tail]) do
    memoized = Agent.get(__MODULE__, &Map.get(&1, curr))

    if memoized do
      memoized
    else
      if hd - curr > 3 do
        0
      else
        count = countPermutations(hd, tail) + countPermutations(curr, tail)
        Agent.update(__MODULE__, &Map.put(&1, curr, count))
        count
      end
    end
  end

  # part1
  defp countIncrements([_], count), do: countIncrements([], count)
  defp countIncrements([], count), do: count

  defp countIncrements([first, second | tail], {ones, threes}) do
    case second - first do
      1 -> countIncrements([second | tail], {ones + 1, threes})
      2 -> countIncrements([second | tail], {ones, threes})
      3 -> countIncrements([second | tail], {ones, threes + 1})
      _ -> nil
    end
  end

  def parseInput(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&String.to_integer(&1))
    |> (fn input -> [0 | input] ++ [Enum.max(input) + 3] end).()
    |> Enum.sort()
  end
end
