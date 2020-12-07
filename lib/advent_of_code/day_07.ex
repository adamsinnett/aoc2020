defmodule AdventOfCode.Day07 do
  def part1(bags) do
    Enum.map(Map.keys(bags), &dfs(bags, &1, "shiny gold bag"))
    |> Enum.sum()
  end

  def part2(bags) do
    countInteriorBags(bags, "shiny gold bag")
  end

  def parseInput(input) do
    String.split(input, "\n", trim: true)
    |> Enum.reject(&String.contains?(&1, "no other bags"))
    |> Enum.map(&String.replace(&1, "bags", "bag"))
    |> Enum.map(&String.replace(&1, ".", ""))
    |> Enum.map(&String.split(&1, "contain", trim: true))
    |> Enum.reduce(%{}, &intoTree(&1, &2))
  end

  def countInteriorBags(bagtree, root) do
    case Map.fetch(bagtree, root) do
      {:ok, bags} ->
        Enum.reduce(bags, 0, fn [num, bag], acc ->
          acc + String.to_integer(num) + String.to_integer(num) * countInteriorBags(bagtree, bag)
        end)

      :error ->
        0
    end
  end

  defp dfs(tree, root, targetNode) do
    case Map.fetch(tree, root) do
      {:ok, leaf} ->
        case Enum.any?(leaf, fn [_, bag] -> bag == targetNode end) do
          true ->
            1

          false ->
            found =
              Enum.map(leaf, fn [_, bag] -> dfs(tree, bag, targetNode) end)
              |> Enum.any?(fn s -> s == 1 end)

            case found do
              true -> 1
              false -> 0
            end
        end

      :error ->
        0
    end
  end

  defp intoTree([parent, nodes], acc) do
    bags =
      String.split(nodes, ",", trim: true)
      |> Enum.map(&String.split(&1, " ", parts: 2, trim: true))

    Map.put(acc, String.trim(parent), bags)
  end
end
