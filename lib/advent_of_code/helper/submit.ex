defmodule Submit do
  def submit(year, day, part, answer) do
    params = Params.parse(year, day)

    case part do
      n when n == 1 or n == 2 -> doSubmit(part, answer)
      _ -> throw("Don't understand what part you're trying to submit")
    end
  end

  defp doSubmit(_part, _answer) do
    # TODO
  end
end
