defmodule AdventOfCode.Day05 do
  def part1(input) do
    Enum.map(input, &resolveSeatNumber(&1))
    |> Enum.max()
  end

  def part2(input) do
    Enum.map(input, &resolveSeatNumber(&1))
    |> Enum.sort()
    |> Enum.chunk_every(2, 1)
    |> Enum.find(fn [fir, sec] -> fir + 1 != sec end)
    |> (fn [neighbor, _] -> neighbor + 1 end).()
  end

  def parseInput(input) do

    
    String.split(input, "\n", trim: true)
  end

  defp resolveSeatNumber(ticket) do
    row =
      String.slice(ticket, 0, 7)
      |> String.replace("F", "0")
      |> String.replace("B", "1")
      |> String.to_integer(2)

    col =
      String.slice(ticket, 7, 3)
      |> String.replace("L", "0")
      |> String.replace("R", "1")
      |> String.to_integer(2)

    row * 8 + col
  end
end
