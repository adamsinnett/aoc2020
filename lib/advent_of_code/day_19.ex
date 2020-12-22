defmodule AdventOfCode.Day19 do
  def part1({rules, messages}) do
    buildList("0", rules)
    |> filter(messages)
    |> Enum.count()
  end

  def part2({rules, messages}) do
    fortytwo = buildList("42", rules)
    thirtyone = buildList("31", rules)

    Enum.filter(messages, &Enum.member?(fortytwo, String.slice(&1, 0..7)))
    |> Enum.filter(&isValid(&1, fortytwo, thirtyone, 0))
    |> Enum.count()
  end

  defp isValid(message, fortytwo, thirtyone, count) do
    len = String.length(message)

    case Enum.member?(fortytwo, String.slice(message, 0..7)) do
      false ->
        false

      true ->
        suffix = String.slice(message, 8..len)
        endsWith(suffix, thirtyone, count) or isValid(suffix, fortytwo, thirtyone, count + 1)
    end
  end

  defp endsWith(_, _, count) when count < 0, do: false

  defp endsWith(message, thirtyone, count) do
    len = String.length(message)

    case Enum.member?(thirtyone, String.slice(message, 0..7)) do
      true -> endsWith(String.slice(message, 8..len), thirtyone, count - 1)
      false -> count >= 0
    end
  end

  defp filter(rules, messages) do
    Enum.filter(messages, &Enum.member?(rules, &1))
  end

  defp buildList(key, map) do
    case Map.fetch!(map, key) do
      "a" ->
        ["a"]

      "b" ->
        ["b"]

      rule ->
        Enum.map(String.split(rule, " | "), fn rules ->
          buildSublist(String.split(rules, " "), map)
        end)
        |> List.flatten()
    end
  end

  def buildSublist([first], map), do: buildList(first, map)

  def buildSublist([first, second], map) do
    for f <- buildList(first, map), s <- buildList(second, map) do
      f <> s
    end
  end

  defp parseRule([key, "\"a\""]), do: {key, "a"}
  defp parseRule([key, "\"b\""]), do: {key, "b"}
  defp parseRule([key, rule]), do: {key, rule}

  def parseInput(input) do
    [rules, messages] = String.split(input, "\n\n", trim: true)

    {String.split(rules, "\n")
     |> Enum.map(&String.split(&1, ": "))
     |> Enum.map(&parseRule/1)
     |> Enum.into(%{}), String.split(messages, "\n")}
  end
end
