defmodule AdventOfCode.Day18 do
  def part1(input) do
    input
    |> Enum.map(&String.replace(&1, " ", ""))
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn line -> buildTree(line, []) |> computeTree end)
    |> Enum.sum()
  end

  def part2(input) do
    Enum.map(input, fn line -> String.to_charlist(line) |> :lex.string end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(& :parse.parse &1)
    |> Enum.map(fn parse -> elem(parse,1) |> computeParse end)
    |> Enum.sum
  end

  def computeParse({:mult, left, right}), do: computeParse(left) * computeParse(right)
  def computeParse({:plus, left, right}), do: computeParse(left) + computeParse(right)
  def computeParse({:int, left, right}), do: right

  def computeTree(%Tree{aval: "*", left: left, right: right}),
    do: computeTree(left) * computeTree(right)

  def computeTree(%Tree{aval: "+", left: left, right: right}),
    do: computeTree(left) + computeTree(right)

  def computeTree(num), do: String.to_integer(num)


  # part1
  defp buildTree([], stack), do: hd(stack)

  defp buildTree([num], []), do: [num]

  defp buildTree(["(" | tail], stack) do
    {subtree, rest} = buildTree(tail, stack)
    buildTree(rest, [subtree])
  end

  defp buildTree([")" | tail], stack), do: {hd(stack), tail}

  defp buildTree(["*" | tail], stack) do
    case hd(tail) do
      "(" ->
        {subtree, rest} = buildTree(tl(tail), tl(stack))
        buildTree(rest, [%Tree{aval: "*", left: subtree, right: hd(stack)}] ++ tl(stack))

      num ->
        buildTree(tl(tail), [%Tree{aval: "*", left: hd(stack), right: num}] ++ tl(stack))
    end
  end

  defp buildTree(["+" | tail], stack) do
    case hd(tail) do
      "(" ->
        {subtree, rest} = buildTree(tl(tail), tl(stack))
        buildTree(rest, [%Tree{aval: "+", left: subtree, right: hd(stack)}] ++ tl(stack))

      num ->
        buildTree(tl(tail), [%Tree{aval: "+", left: hd(stack), right: num}] ++ tl(stack))
    end
  end

  defp buildTree([num | tail], stack), do: buildTree(tail, [num] ++ stack)

  def parseInput(input) do
    String.split(input, "\n", trim: true)
  end
end
