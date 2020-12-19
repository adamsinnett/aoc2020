defmodule AdventOfCode.Day17 do
  def part1(input) do
    Enum.reduce(1..6, input, fn _, map -> solveThreeDimensions(map) end)
    |> Enum.count()
  end

  def part2(input) do
    Enum.reduce(1..6, input, fn _, map -> solveFourDimensions(map) end)
    |> Enum.count()
  end

  defp solveThreeDimensions(state) do
    grid = Map.keys(state)
    xs = grid |> Enum.map(&elem(&1, 0)) |> getRange
    ys = grid |> Enum.map(&elem(&1, 1)) |> getRange
    zs = grid |> Enum.map(&elem(&1, 2)) |> getRange

    Enum.reduce(xs, %{}, fn x, accx ->
      Enum.reduce(ys, accx, fn y, accy ->
        Enum.reduce(zs, accy, fn z, accz ->
          update(Map.fetch(state, {x, y, z, 0}), {x, y, z}, accz, state)
        end)
      end)
    end)
  end

  defp solveFourDimensions(state) do
    grid = Map.keys(state)
    xs = grid |> Enum.map(&elem(&1, 0)) |> getRange
    ys = grid |> Enum.map(&elem(&1, 1)) |> getRange
    zs = grid |> Enum.map(&elem(&1, 2)) |> getRange
    ws = grid |> Enum.map(&elem(&1, 3)) |> getRange

    Enum.reduce(xs, %{}, fn x, accx ->
      Enum.reduce(ys, accx, fn y, accy ->
        Enum.reduce(zs, accy, fn z, accz ->
          Enum.reduce(ws, accz, fn w, accw ->
            update(Map.fetch(state, {x, y, z, w}), {x, y, z, w}, accw, state)
          end)
        end)
      end)
    end)
  end

  defp countNeighbors({x, y, z, w}, state) do
    Enum.reduce((x - 1)..(x + 1), 0, fn xn, accx ->
      Enum.reduce((y - 1)..(y + 1), accx, fn yn, accy ->
        Enum.reduce((z - 1)..(z + 1), accy, fn zn, accz ->
          Enum.reduce((w - 1)..(w + 1), accz, fn wn, accw ->
            if {x, y, z, w} == {xn, yn, zn, wn} do
              accw
            else
              case Map.fetch(state, {xn, yn, zn, wn}) do
                :error -> accw
                _ -> accw + 1
              end
            end
          end)
        end)
      end)
    end)
  end

  defp countNeighbors({x, y, z}, state) do
    Enum.reduce((x - 1)..(x + 1), 0, fn xn, accx ->
      Enum.reduce((y - 1)..(y + 1), accx, fn yn, accy ->
        Enum.reduce((z - 1)..(z + 1), accy, fn zn, accz ->
          if {x, y, z} == {xn, yn, zn} do
            accz
          else
            case Map.fetch(state, {xn, yn, zn, 0}) do
              :error -> accz
              _ -> accz + 1
            end
          end
        end)
      end)
    end)
  end

  defp print3d(state) do
    grid = Map.keys(state)
    xs = grid |> Enum.map(&elem(&1, 0)) |> getRange
    ys = grid |> Enum.map(&elem(&1, 1)) |> getRange
    zs = grid |> Enum.map(&elem(&1, 2)) |> getRange

    Enum.each(zs, fn z ->
      IO.puts("layer z=#{z}")

      Enum.each(xs, fn x ->
        Enum.each(ys, fn y ->
          case Map.fetch(state, {x, y, z, 0}) do
            {:ok, _} -> IO.write("#")
            :error -> IO.write(".")
          end
        end)

        IO.write("\n")
      end)
    end)
  end

  defp update(:error, current, new, old) do
    case countNeighbors(current, old) do
      3 ->
        Map.put(new, current, :occupied)

      _ ->
        new
    end
  end

  defp update({:ok, _}, current, new, old) do
    case countNeighbors(current, old) do
      n when n == 2 or n == 3 -> Map.put(new, current, :occupied)
      _ -> Map.delete(new, current)
    end
  end

  defp getRange(nums) do
    (Enum.min(nums) - 1)..(Enum.max(nums) + 1)
  end

  def parseInput(input) do
    String.split(
      input,
      "\n",
      trim: true
    )
    |> Enum.map(&String.graphemes/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, x}, acc ->
      Enum.with_index(line)
      |> Enum.reduce(acc, fn {cell, y}, accu ->
        case cell do
          "#" -> Map.put(accu, {x, y, 0, 0}, :occupied)
          "." -> accu
        end
      end)
    end)
  end
end
