defmodule AdventOfCode.Day07 do
  def part1(input) do
    bagTree =
      Enum.reject(input, &String.contains?(&1, "no other bags"))
      |> Enum.map(&String.replace(&1, "bags", "bag"))
      |> Enum.map(&String.replace(&1, ".", ""))
      |> Enum.map(&String.split(&1, "contain", trim: true))
      |> Enum.reduce(%{}, &intoTree(&1, &2))

    findEdgeCount(bagTree, "shiny gold bag")
    |> length
  end

  def part2(_input) do
  end

  def parseInput(input) do
    String.split(input, "\n", trim: true)
  end

  defp findEdgeCount(tree, root) do
    case Map.fetch(tree, root) do
      {:ok, value} -> Enum.flat_map(value, &findEdgeCount(tree, &1))
      :error -> [root]
    end
  end

  defp intoTree([parent, nodes], acc) do
    bags =
      String.replace(nodes, ~r/\s\d\s/, "")
      |> String.split(",", trim: true)
      |> Enum.map(&String.trim(&1))

    Enum.reduce(bags, acc, fn bag, bagAcc ->
      case Map.fetch(bagAcc, bag) do
        {:ok, value} -> Map.put(bagAcc, bag, Enum.uniq(value ++ [String.trim(parent)]))
        :error -> Map.put(bagAcc, bag, [String.trim(parent)])
      end
    end)
  end
end
