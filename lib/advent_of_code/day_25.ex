defmodule AdventOfCode.Day25 do
  def part1([card, door]) do
    loop = findLoop(card)
    generate_public_key(20_201_227, door, loop)
  end

  defp findLoop(card, loop \\ 1, n \\ 1) do
    m = Integer.mod(n * 7, 20_201_227)

    case m == card do
      true -> loop
      false -> findLoop(card, loop + 1, m)
    end
  end

  def generate_public_key(mod, base, exp) do
    :crypto.mod_pow(base, exp, mod)
    |> :crypto.bytes_to_integer
  end

  def part2(_input) do
    # Merry christmas
  end

  def parseInput(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
