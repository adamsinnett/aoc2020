defmodule AdventOfCode.Day08 do
  def part1(stack) do
    {acc, pos} = run(0, stack, 0, [])
    pos
  end

  def part2(stack) do
    fixStack(stack, 0)
  end

  def parseInput(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [op, arg] -> {op, String.to_integer(arg)} end)
  end

  defp fixStack(stack, idx) do
    {op, arg} = Enum.at(stack, idx)
    {acc, pos} = run(0, swap(stack, idx, op, arg), 0, [])

    cond do
      pos == length(stack) ->
        acc

      true ->
        fixStack(deswap(stack, idx, op, arg), idx + 1)
    end
  end

  defp swap(stack, idx, "jmp", arg) do
    List.replace_at(stack, idx, {"nop", arg})
  end

  defp swap(stack, idx, "nop", arg) do
    List.replace_at(stack, idx, {"jmp", arg})
  end

  defp swap(stack, idx, "acc", arg) do
    List.replace_at(stack, idx, {"acc", arg})
  end

  defp deswap(stack, idx, op, arg) do
    List.replace_at(stack, idx, {op, arg})
  end

  defp run(pos, stack, acc, history \\ []) do
    if Enum.member?(history, pos) or pos >= length(stack) do
      {acc, pos}
    else
      {op, arg} = Enum.at(stack, pos)

      case op do
        "acc" ->
          run(pos + 1, stack, acc + arg, history ++ [pos])

        "jmp" ->
          run(pos + arg, stack, acc, history ++ [pos])

        "nop" ->
          run(pos + 1, stack, acc, history ++ [pos])
      end
    end
  end
end
