defmodule AdventOfCode.Day11 do
  def part1(input) do
    solve(input, &adjacent/2, 4)
  end

  def part2(input) do
    solve(input, &visible/2, 5)
  end

  def solve(input, search, allowed) do
    input
    |> run(search, allowed)
    |> Map.values()
    |> Enum.count(&(&1 == "#"))
  end

  def run(prev, search, allowed) do
    new = turn(prev, search, allowed)

    case Map.equal?(new, prev) do
      true -> new
      false -> run(new, search, allowed)
    end
  end

  def turn(m, search, allowed) do
    m
    |> Enum.map(fn
      {k, "."} -> {k, "."}
      {k, "L"} -> {k, if(Enum.any?(search.(k, m), &(&1 == "#")), do: "L", else: "#")}
      {k, "#"} -> {k, if(Enum.count(search.(k, m), &(&1 == "#")) >= allowed, do: "L", else: "#")}
    end)
    |> Map.new()
  end

  def adjacent({r, c}, m) do
    for row <- (r - 1)..(r + 1),
        col <- (c - 1)..(c + 1),
        not (row == r and col == c) do
      Map.get(m, {row, col}, ".")
    end
  end

  def visible({r, c}, m) do
    Enum.map(
      [
        fn {r, c} -> {r - 1, c} end,
        fn {r, c} -> {r + 1, c} end,
        fn {r, c} -> {r, c - 1} end,
        fn {r, c} -> {r, c + 1} end,
        fn {r, c} -> {r - 1, c - 1} end,
        fn {r, c} -> {r + 1, c + 1} end,
        fn {r, c} -> {r - 1, c + 1} end,
        fn {r, c} -> {r + 1, c - 1} end
      ],
      &find({r, c}, m, &1)
    )
  end

  def find(k, m, next) do
    key = next.(k)

    case m[key] do
      "." -> find(key, m, next)
      nil -> "."
      any -> any
    end
  end

  # input
  def parseInput(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index()
    |> Enum.flat_map(fn {rs, r} -> Enum.map(rs, fn {seat, c} -> {{r, c}, seat} end) end)
    |> Map.new()
  end
end
