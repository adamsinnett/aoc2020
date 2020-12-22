defmodule AdventOfCode.Day22 do
  def part1([p1, p2]), do: playGame(p1, p2)
  def part2([p1, p2]), do: playRecusiveGame(p1, p2) |> elem(1) |> hash

  defp playRecusiveGame(p1, p2, history \\ [])
  defp playRecusiveGame([], p2, _), do: {:p2, p2}
  defp playRecusiveGame(p1, [], _), do: {:p1, p1}

  defp playRecusiveGame(p1, p2, history) do
    p1card = hd(p1)
    p1hand = tl(p1)

    p2card = hd(p2)
    p2hand = tl(p2)

    current = {hash(p1), hash(p2)}

    if Enum.member?(history, current) do
      {:p1, p1}
    else
      cond do
        p1card <= length(p1hand) and p2card <= length(p2hand) ->
          case playRecusiveGame(Enum.take(p1hand, p1card), Enum.take(p2hand, p2card)) do
            {:p1, _} -> playRecusiveGame(p1hand ++ [p1card, p2card], p2hand, [current] ++ history)
            {:p2, _} -> playRecusiveGame(p1hand, p2hand ++ [p2card, p1card], [current] ++ history)
          end

        p1card >= p2card ->
          playRecusiveGame(p1hand ++ [p1card, p2card], p2hand, [current] ++ history)

        p1card < p2card ->
          playRecusiveGame(p1hand, p2hand ++ [p2card, p1card], [current] ++ history)
      end
    end
  end

  defp playGame([], p2), do: hash(p2)
  defp playGame(p1, []), do: hash(p1)

  defp playGame(p1, p2) do
    cond do
      hd(p1) > hd(p2) -> playGame(tl(p1) ++ [hd(p1), hd(p2)], tl(p2))
      hd(p1) < hd(p2) -> playGame(tl(p1), tl(p2) ++ [hd(p2), hd(p1)])
    end
  end

  def hash(cards) do
    Enum.reverse(cards)
    |> Enum.with_index()
    |> Enum.reduce(0, fn {x, i}, acc -> acc + x * (i + 1) end)
  end

  def parseInput(input) do
    String.split(input, "\n\n", trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> Enum.map(&Enum.drop(&1, 1))
    |> Enum.map(fn l -> Enum.map(l, &String.to_integer/1) end)
  end
end
