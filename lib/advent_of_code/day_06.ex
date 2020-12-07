defmodule AdventOfCode.Day06 do
  def part1(input) do
    Enum.map(input, &String.replace(&1, "\n", ""))
    |> Enum.map(&String.to_charlist(&1))
    |> Enum.map(&Enum.uniq(&1))
    |> Enum.map(&length(&1))
    |> Enum.sum()
  end

  def part2(input) do
    Enum.map(input, &String.split(&1))
    |> Enum.map(&mapify(&1))
    |> Enum.map(&intersect(&1))
    |> Enum.map(&MapSet.size(&1))
    |> Enum.sum()
  end

  def parseInput(input) do
    String.split(input, "\n\n", trim: true)
  end

  defp mapify(decls) do
    Enum.map(decls, fn decl -> decl |> String.to_charlist() |> MapSet.new() end)
  end

  defp intersect(decls) do
    Enum.reduce(decls, fn decl, acc -> MapSet.intersection(acc, decl) end)
  end
end
