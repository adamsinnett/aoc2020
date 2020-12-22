defmodule AdventOfCode.Day21 do
  def part1(input) do
    allergens = Enum.map(input, &elem(&1, 1)) |> List.flatten() |> Enum.uniq()
    possible = Enum.map(allergens, &findPossibleAllergen(&1, input))

    countNotAllergens(
      possible,
      input
    )
  end

  def part2(input) do
    allergens = Enum.map(input, &elem(&1, 1)) |> List.flatten() |> Enum.uniq()
    possible = Enum.map(allergens, &findPossibleAllergen(&1, input))

    findAllergen(
      Enum.filter(possible, fn {_, p} -> MapSet.size(p) != 1 end),
      Enum.filter(possible, fn {_, p} -> MapSet.size(p) == 1 end)
    )
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(&MapSet.to_list/1)
    |> Enum.join(",")
  end

  # Part 2

  defp findAllergen([], allergens), do: allergens

  defp findAllergen(canidates, allergens) do
    possible =
      Enum.map(canidates, fn {name, ingredients} ->
        {name,
         Enum.reduce(allergens, ingredients, fn {_, known}, acc ->
           MapSet.difference(acc, known)
         end)}
      end)

    findAllergen(
      Enum.filter(possible, fn {_, p} -> MapSet.size(p) != 1 end),
      Enum.filter(possible, fn {_, p} -> MapSet.size(p) == 1 end) ++ allergens
    )
  end

  # Part 1

  defp countNotAllergens(possible, input) do
    possibleAllergens = Enum.map(possible, &elem(&1, 1))

    Enum.map(input, &elem(&1, 0))
    |> Enum.map(fn ingredients ->
      Enum.reduce(possibleAllergens, ingredients, fn p, i -> MapSet.difference(i, p) end)
    end)
    |> Enum.map(&MapSet.to_list/1)
    |> List.flatten()
    |> Enum.count()
  end

  defp findPossibleAllergen(allergen, inputs) do
    {
      allergen,
      Enum.filter(inputs, fn {_, allergens} -> Enum.member?(allergens, allergen) end)
      |> Enum.map(&elem(&1, 0))
      |> Enum.reduce(fn ing, acc -> MapSet.intersection(acc, ing) end)
    }
  end

  # Parsing

  def parseInput(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&String.split(&1, " (contains "))
    |> Enum.map(&parseIngredients/1)
  end

  defp parseIngredients([ingredients, allergens]) do
    {
      MapSet.new(String.split(ingredients, " ")),
      String.replace(allergens, ")", "") |> String.split(", ", trim: true)
    }
  end
end
