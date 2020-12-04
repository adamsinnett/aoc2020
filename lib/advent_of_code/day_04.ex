defmodule AdventOfCode.Day04 do
  def part1(input) do
    Enum.count(input, &hasFields(&1))
  end

  def part2(input) do
    Enum.filter(input, &hasFields(&1))
    |> Enum.count(&hasValidatedFields(&1))
  end

  def parseInput(input) do
    String.split(input, "\n\n", trim: true)
    |> Enum.map(&String.replace(&1, "\n", " "))
  end

  defp hasValidatedFields(passport) do
    valid(~r/byr:(\d{4})/, passport, &isBetween?(&1, 1920, 2002)) and
      valid(~r/iyr:(\d{4})/, passport, &isBetween?(&1, 2010, 2020)) and
      valid(~r/eyr:(\d{4})/, passport, &isBetween?(&1, 2020, 2030)) and
      (valid(~r/hgt:(\d{2,3})cm/, passport, &isBetween?(&1, 150, 193)) or
         valid(~r/hgt:(\d{2})in/, passport, &isBetween?(&1, 59, 76))) and
      valid(~r/hcl:(#[0-9a-f]{6})/, passport) and
      valid(~r/ecl:([\w]{3})/, passport, &validEyeColor?(&1)) and
      valid(~r/pid:([0-9]{9})/, passport)
  end

  defp valid(regex, passport, validator \\ fn _ -> true end) do
    case Regex.run(regex, passport) do
      [_, match] -> validator.(match)
      _ -> false
    end
  end

  defp validEyeColor?(color) do
    "amb blu brn gry grn hzl oth" =~ color
  end

  defp isBetween?(value, low, high) do
    String.to_integer(value) >= low and String.to_integer(value) <= high
  end

  defp hasFields(passport) do
    Enum.reduce(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"], true, fn field, acc ->
      acc and String.contains?(passport, field)
    end)
  end
end
