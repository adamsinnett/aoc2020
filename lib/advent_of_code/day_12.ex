defmodule AdventOfCode.Day12 do
  def part1(input) do
    moveShip({0, 0, :east}, input)
    |> (fn {x, y, _} -> abs(x) + abs(y) end).()
  end

  def part2(input) do
    moveShipAndWaypoint({0, 0, 10, 1}, input)
    |> (fn {x, y, _, _} -> abs(x) + abs(y) end).()
  end

  # part2
  defp moveShipAndWaypoint(coords, []), do: coords

  defp moveShipAndWaypoint(coords, [{inst, amt} | tail]) do
    case inst do
      d when d == "L" or d == "R" -> rotate(coords, inst, amt) |> moveShipAndWaypoint(tail)
      _ -> doInstW(inst, amt, coords) |> moveShipAndWaypoint(tail)
    end
  end

  defp rotate({x, y, wx, wy}, "L", 90), do: {x, y, -wy, wx}
  defp rotate({x, y, wx, wy}, "R", 90), do: {x, y, wy, -wx}
  defp rotate(coords, d, 180), do: rotate(coords, d, 90) |> rotate(d, 90)
  defp rotate(coords, d, 270), do: rotate(coords, d, 90) |> rotate(d, 90) |> rotate(d, 90)

  defp doInstW("F", amt, {x, y, wx, wy}), do: {x + wx * amt, y + wy * amt, wx, wy}

  defp doInstW("E", amt, {x, y, wx, wy}), do: {x, y, wx + amt, wy}
  defp doInstW("W", amt, {x, y, wx, wy}), do: {x, y, wx - amt, wy}
  defp doInstW("N", amt, {x, y, wx, wy}), do: {x, y, wx, wy + amt}
  defp doInstW("S", amt, {x, y, wx, wy}), do: {x, y, wx, wy - amt}

  # part1
  defp moveShip(coords, []), do: coords

  defp moveShip(coords, [{inst, amt} | tail]) do
    case inst do
      d when d == "L" or d == "R" -> changeDir(inst, amt, coords) |> moveShip(tail)
      _ -> doInst(inst, amt, coords) |> moveShip(tail)
    end
  end

  defp changeDir("L", amt, {x, y, dir}) do
    compass = [:north, :west, :south, :east]
    rot = div(amt, 90)

    case Enum.find_index(compass, &(&1 == dir)) do
      nil -> IO.puts("oops")
      d -> {x, y, Enum.at(compass, rem(d + rot, 4))}
    end
  end

  defp changeDir("R", amt, {x, y, dir}) do
    compass = [:north, :east, :south, :west]
    rot = div(amt, 90)

    case Enum.find_index(compass, &(&1 == dir)) do
      nil -> IO.put("oops")
      d -> {x, y, Enum.at(compass, rem(d + rot, 4))}
    end
  end

  defp doInst("F", amt, {x, y, :east}), do: {x + amt, y, :east}
  defp doInst("F", amt, {x, y, :west}), do: {x - amt, y, :west}
  defp doInst("F", amt, {x, y, :north}), do: {x, y + amt, :north}
  defp doInst("F", amt, {x, y, :south}), do: {x, y - amt, :south}

  defp doInst("E", amt, {x, y, dir}), do: {x + amt, y, dir}
  defp doInst("W", amt, {x, y, dir}), do: {x - amt, y, dir}
  defp doInst("N", amt, {x, y, dir}), do: {x, y + amt, dir}
  defp doInst("S", amt, {x, y, dir}), do: {x, y - amt, dir}

  def parseInput(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(fn s -> Regex.run(~r/(\w)(\d+)/, s) end)
    |> Enum.map(fn [_, a, b] -> {a, String.to_integer(b)} end)
  end
end
