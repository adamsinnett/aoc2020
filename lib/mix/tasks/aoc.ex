defmodule Mix.Tasks.Aoc do
  use Mix.Task

  @shortdoc "Run advent of code via mix aoc <day> <part>"
  def run(args) do
    year = 2020
    [day, part | rest] = args

    input = Input.getInput(year, day)
    paddedDay = to_string(day) |> String.pad_leading(2, "0")
    module = String.to_atom("Elixir.AdventOfCode.Day" <> paddedDay)
    partFn = getPartFn(part)

    parsed = apply(module, :parseInput, [input])

    if Enum.member?(rest, "-b") do
      Benchee.run(%{part_1: fn -> apply(module, partFn, [parsed]) end})
    else
      answer = apply(module, partFn, [parsed])
      IO.puts("Answer: #{answer}")

      case length(rest) do
        1 ->
          Submit.submit(answer, year, day, part)
          |> (fn ans -> IO.puts("Result: #{ans}") end).()

        _ ->
          IO.puts("not submitted")
      end
    end
  end

  defp getPartFn(part) do
    case part do
      "1" -> :part1
      "2" -> :part2
    end
  end
end
