defmodule AdventOfCode.Day24 do
  def part1(input) do
    Enum.map(input, &findCoords/1)
    |> Enum.reduce(MapSet.new(), &fillIn/2)
    |> Enum.count()
  end

  def part2(input) do
    Enum.map(input, &findCoords/1)
    |> Enum.reduce(MapSet.new(), &fillIn/2)
    |> Stream.iterate(&day/1)
    |> Enum.at(100)
    |> Enum.count()
  end

  defp day(tiles) do
    tiles
    |> Enum.map(&mutate(&1, tiles))
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.into(%MapSet{})
  end

  defp mutate(coord, tiles) do
    adjacent(coord)
    |> Enum.split_with(&MapSet.member?(tiles, &1))
    |> (fn {black, white} -> flipWhite(coord, black) ++ flipBlack(white, tiles) end).()
  end

  defp flipWhite(_, neighbors) when length(neighbors) == 0, do: []
  defp flipWhite(_, neighbors) when length(neighbors) > 2, do: []
  defp flipWhite(coord, _), do: [coord]

  defp flipBlack(coords, tiles) do
    Enum.filter(coords, &hasNeighbors?(&1, 2, tiles))
  end

  defp hasNeighbors?(coord, count, tiles) do
    count ==
      adjacent(coord)
      |> Enum.filter(&MapSet.member?(tiles, &1))
      |> length
  end

  defp adjacent({q, r}) do
    [
      {q, r - 1},
      {q + 1, r - 1},
      {q + 1, r},
      {q, r + 1},
      {q - 1, r + 1},
      {q - 1, r}
    ]
  end

  defp fillIn(coord, map) do
    case MapSet.member?(map, coord) do
      true -> MapSet.delete(map, coord)
      false -> MapSet.put(map, coord)
    end
  end

  defp findCoords(input, curr \\ {0, 0})
  defp findCoords("e" <> rest, {q, r}), do: findCoords(rest, {q + 1, r})
  defp findCoords("se" <> rest, {q, r}), do: findCoords(rest, {q, r + 1})
  defp findCoords("sw" <> rest, {q, r}), do: findCoords(rest, {q - 1, r + 1})
  defp findCoords("w" <> rest, {q, r}), do: findCoords(rest, {q - 1, r})
  defp findCoords("nw" <> rest, {q, r}), do: findCoords(rest, {q, r - 1})
  defp findCoords("ne" <> rest, {q, r}), do: findCoords(rest, {q + 1, r - 1})
  defp findCoords("", {q, r}), do: {q, r}

  def parseInput(input) do
    String.split(
      input,
      "\n",
      trim: true
    )
  end
end
