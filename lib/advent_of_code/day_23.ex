defmodule AdventOfCode.Day23 do
  def part1(cups) do
    finished = playGame(cups, 0, 100)

    #find one and rotate around it, but not include it
    one = Enum.find_index(finished, &(&1 == 1))
    Enum.drop(finished, one+1) ++ Enum.take(finished, one)
    |> Enum.join("")
  end

  def part2(_input) do
  end

  # PART 1 - Too much list - manual entry

  defp playGame(cups, current, move) when current == length(cups), do: playGame(cups, 0, move)
  defp playGame(cups, _, move) when move == 0, do: cups

  defp playGame(cups, currindex, move) do
    # find game pieces
    current = Enum.at(cups, currindex)
    pickup = sliceOutThreeAt(cups, currindex + 1)
    sliced = Enum.filter(cups, fn i -> not Enum.member?(pickup, i) end)
    destination = findDestination(current, sliced)
    # splice
    di = Enum.find_index(sliced, &(&1 == destination))
    updated = Enum.take(sliced, di + 1) ++ pickup ++ Enum.drop(sliced, di + 1)

    playGame(updated, Enum.find_index(updated, &(&1 == current)) + 1, move - 1)
  end

  defp sliceOutThreeAt(cups, index, count \\ 0)

  defp sliceOutThreeAt(cups, index, count) when index == length(cups),
    do: sliceOutThreeAt(cups, 0, count)

  defp sliceOutThreeAt(_, _, count) when count == 3, do: []

  defp sliceOutThreeAt(cups, index, count) do
    [Enum.at(cups, index)] ++ sliceOutThreeAt(cups, index + 1, count + 1)
  end

  defp findDestination(current, sliced) when current < 1, do: findDestination(10, sliced)

  defp findDestination(current, sliced) do
    case Enum.member?(sliced, current - 1) do
      true -> current - 1
      false -> findDestination(current - 1, sliced)
    end
  end

  def parseInput(input),
    do: String.trim(input) |> String.graphemes() |> Enum.map(&String.to_integer/1)
end
