defmodule AdventOfCode.Day14 do
  use Bitwise

  def part1(input), do: reduce(input, nil, %{}, &maskValue/4)
  def part2(input), do: reduce(input, nil, %{}, &maskMem/4)

  defp reduce([], _, mem, _), do: Map.values(mem) |> Enum.sum()
  defp reduce([{:mask, mask} | tail], _, mem, func), do: reduce(tail, mask, mem, func)
  defp reduce([{:mem, loc, value} | tail], mask, mem, func),
    do: reduce(tail, mask, func.(mem, loc, value, mask), func)

  # Part 2 masker

  defp maskMem(mem, loc, value, mask) do
    findLocs(loc, mask)
    |> Enum.reduce(mem, &Map.put(&2, &1, value))
  end

  defp findLocs(loc, []), do: [loc]
  defp findLocs(loc, [{"X", i} | tail]),
    do: findLocs(loc &&& bnot(1 <<< i), tail) ++ findLocs(loc ||| 1 <<< i, tail)
  defp findLocs(loc, [{"0", _} | tail]), do: findLocs(loc, tail)
  defp findLocs(loc, [{"1", i} | tail]), do: findLocs(loc ||| 1 <<< i, tail)

  # Part 1 masker

  defp maskValue(mem, loc, value, mask) do
    maskedValue = Enum.reduce(mask, value, &bitmask/2)
    Map.put(mem, loc, maskedValue)
  end

  defp bitmask({"X", _}, value), do: value
  defp bitmask({"0", i}, value), do: value &&& bnot(1 <<< i)
  defp bitmask({"1", i}, value), do: value ||| 1 <<< i

  # parse
  def parseInput(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&parse/1)
  end

  defp parse("mask = " <> mask), do: {:mask, String.graphemes(mask) |> Enum.reverse() |> Enum.with_index()}
  defp parse("mem[" <> cmd), do: Regex.run(~r/(\d+)\]\s=\s(\d+)/, cmd) |> parseMem
  defp parseMem([_, mem, value]), do: {:mem, String.to_integer(mem), String.to_integer(value)}
end
