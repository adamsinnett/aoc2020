defmodule AdventOfCode.Day11 do
  def part1(map) do
    fillChairs(map, 0)
  end

  def part2(_input) do
  end

  # part1
  defp fillChairs(map, total) do
    chairsFilled =
      fillChair({0, 0}, map)
      |> Enum.values()
      |> List.flatten()
      |> Enum.filter(&(&1 == "#"))
      |> length

    case chairsFilled == total do
      false -> fillChairs(map, chairsFilled)
    end
  end

  defp fillChair({x, y}, map) do
    if not Map.has_key?({x, y}) do
      map
    else
      seat = Map.fetch!({x, y})
      neighbors = numberOfOccupiedNeighhbors({x, y}, map)
    end
  end

  defp numberOfOccupiedNeighhbors({x, y}, map) do
    filled({x - 1, y - 1}, map) + filled({x, y - 1}, map) + filled({x + 1, y - 1}, map) +
      filled({x - 1, y}, map) + filled({x + 1, y}, map) + filled({x - 1, y + 1}, map) +
      filled({x, y + 1}, map) + filled({x + 1, y + 1}, map)
  end

  defp filled(pos, map) do
    case Map.has_key?(pos) do
      true ->
        case Map.fetch!(pos) do
          "#" -> 1
          _ -> 0
        end

      _ ->
        0
    end
  end

  # input
  def parseInput(input) do
    matrix =
      String.split(input, "\n", trim: true)
      |> Enum.map(&String.graphemes(&1))

    maxx = matrix |> length
    maxy = matrix |> hd |> length
    list = List.flatten(matrix)

    map =
      Enum.reduce(
        0..maxx,
        %{},
        fn x, acc ->
          Map.merge(
            acc,
            Enum.reduce(
              0..maxy,
              %{},
              fn y, accu -> Map.put(accu, {x, y}, Enum.at(list, x * maxy + y)) end
            )
          )
        end
      )

    {map, maxx, maxy}
  end
end
