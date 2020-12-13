defmodule AdventOfCode.Day13 do
  def part1({target, lines}) do
    lines
    |> Enum.map(fn {line, _} -> line end)
    |> Enum.map(fn x -> {x, x - Integer.mod(target, x)} end)
    |> Enum.sort_by(fn {_, x} -> x end)
    |> hd
    |> (fn {bus, wait} -> bus * wait end).()
  end

  def part2({_, lines}) do
    chineseRemainerTherom(lines)
  end

  defp chineseRemainerTherom(lines) do
    product = Enum.reduce(lines, 1, fn {m, _}, acc -> m * acc end)

    Enum.map(lines, &step(&1, product))
    |> Enum.sum()
    |> rem(product)
    |> (fn x -> product - x end).()
  end

  defp step({m, r}, product) do
    div(product, m)
    |> findEgcd(m, 1)
    |> (fn {ndiv, s} -> r * s * ndiv end).()
  end

  def findEgcd(ndiv, m, s) do
    case rem(s * ndiv, m) do
      1 -> {s, ndiv}
      _ -> findEgcd(ndiv, m, s + 1)
    end
  end

  def parseInput(input) do
    [target, buslines] = String.split(input, "\n", trim: true)

    lines =
      String.split(buslines, ",", trim: true)
      |> Enum.with_index()
      |> Enum.filter(fn {line, _} -> line != "x" end)
      |> Enum.map(fn {line, idx} -> {String.to_integer(line), idx} end)

    {String.to_integer(target), lines}
  end
end
