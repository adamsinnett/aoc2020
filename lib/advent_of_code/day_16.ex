defmodule AdventOfCode.Day16 do
  def part1({rules, _, tickets}) do
    compress(rules, nil)
    |> findViolations(tickets)
    |> List.flatten()
    |> Enum.sum()
  end

  def part2({rules, yours, theirs}) do
    findFields(theirs, rules, [])
    |> Enum.zip(yours)
    |> Enum.filter(fn {rule, _} -> String.contains?(rule, "depature") end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.reduce(&(&1 * &2))
  end

  defp findFields([], _, fields), do: fields

  defp findFields([hd | tail], rules, fields) do
    curr = Enum.map(hd, &findValidFields(&1, rules))
    findFields(tail, rules, join(curr, fields))
  end

  defp join(curr, []), do: curr
  defp join([], _), do: []

  defp join([curr | ctail], [fields | ftail]) do
    case length(curr) < length(fields) do
      true -> [curr] ++ join(ctail, ftail)
      false -> [fields] ++ join(ctail, ftail)
    end
  end

  defp findValidFields(n, rules) do
    IO.inspect(n)

    Enum.filter(rules, fn rule ->
      {_, [low, midlow, midhigh, high]} = rule
      Enum.member?(low..midlow, n) or Enum.member?(midhigh..high, n)
    end)
    |> IO.inspect()
    |> Enum.map(&elem(&1, 0))
  end

  defp findValid({low, midlow, midhigh, high}, tickets) do
    Enum.map(tickets, fn ticket ->
      Enum.reject(ticket, fn n -> n < low or (n > midlow and n < midhigh) or n > high end)
    end)
  end

  # part1

  defp findViolations({low, midlow, midhigh, high}, tickets) do
    Enum.map(tickets, fn ticket ->
      Enum.filter(ticket, fn n -> n < low or (n > midlow and n < midhigh) or n > high end)
    end)
  end

  defp compress([], rules), do: rules

  defp compress([{_, [a, b, c, d]} | tail], nil) do
    compress(tail, {a, b, c, d})
  end

  defp compress([{_, [a, b, c, d]} | tail], {w, x, y, z}) do
    low =
      cond do
        a < w -> a
        true -> w
      end

    midlow =
      cond do
        b > x -> b
        true -> x
      end

    midhigh =
      cond do
        c < y -> c
        true -> y
      end

    high =
      cond do
        d > z -> d
        true -> z
      end

    compress(tail, {low, midlow, midhigh, high})
  end

  # parse
  def parseInput(input) do
    [f, s, t] = String.split(input, "\n\n", trim: true)

    ranges =
      String.split(f, "\n")
      |> Enum.map(&String.split(&1, ":", trim: true))
      |> Enum.map(fn [field, rs] -> {field, parseRanges(rs)} end)

    [yours] = parseTickets(s)
    theirs = parseTickets(t)

    {ranges, yours, theirs}
  end

  defp parseTickets(ticket) do
    String.split(ticket, "\n", trim: true)
    |> Enum.drop(1)
    |> Enum.map(&String.split(&1, ",", trim: true))
    |> Enum.map(&Enum.map(&1, fn n -> String.to_integer(n) end))
  end

  defp parseRanges(ranges) do
    String.split(ranges, "or", trim: true)
    |> Enum.flat_map(&String.split(&1, "-"))
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end
end
