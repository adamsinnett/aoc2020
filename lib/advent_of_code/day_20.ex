defmodule AdventOfCode.Day20 do
  def part1(input) do
    Enum.map(input, &findNeighbors(&1, input))
    |> Enum.filter(fn {_, _, _, neighbors} ->
      2 == Enum.filter(neighbors, &(&1 != nil)) |> length
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.reduce(1, &(&1 * &2))
  end

  def part2(input) do
    tiles = Enum.map(input, &findNeighbors(&1, input))

    _corner =
      Enum.find(tiles, fn {_, _, _, neighbors} -> 2 == Enum.filter(neighbors, &(&1 != nil)) end)
  end

  # Part 2

  # defp stitch(tiles) do
  #   tiles
  #   |> IO.inspect()
  # end

  # Part 1

  defp findNeighbors({num, pic, {top, right, left, bottom}}, tiles) do
    north = findMatchingEdge(top, tiles, num)
    east = findMatchingEdge(right, tiles, num)
    west = findMatchingEdge(left, tiles, num)
    south = findMatchingEdge(bottom, tiles, num)

    {num, pic, {top, right, left, bottom}, [north, east, west, south]}
  end

  defp findMatchingEdge(edge, tiles, curr) do
    case Enum.find(tiles, fn {num, _, {n, e, w, s}} ->
           (edge == n or edge == e or edge == w or edge == s or edge == String.reverse(n) or
              edge == String.reverse(e) or edge == String.reverse(w) or edge == String.reverse(s)) and
             num != curr
         end) do
      {num, _, _} -> num
      nil -> nil
    end
  end

  # Parse

  def parseInput(input) do
    String.split(
      input,
      "\n\n",
      trim: true
    )
    |> Enum.map(&parseTile/1)
  end

  defp parseTile("Tile " <> tile) do
    [num, interiorStr] = String.split(tile, ":", trim: true)
    interiorRows = String.split(interiorStr, "\n", trim: true)
    {String.to_integer(num), findPicture(interiorRows), findEdges(interiorRows)}
  end

  defp findPicture(rows) do
    tl(rows)
    |> Enum.take(8)
    |> Enum.map(fn row -> String.graphemes(row) |> tl |> Enum.take(8) end)
  end

  defp findEdges(rows) do
    top = hd(rows)
    bottom = List.last(rows)

    [left, right] =
      Enum.map(rows, fn row -> {hd(String.graphemes(row)), List.last(String.graphemes(row))} end)
      |> Enum.reduce(["", ""], fn {ls, rs}, [l, r] -> [l <> ls, r <> rs] end)

    {top, right, left, bottom}
  end
end
