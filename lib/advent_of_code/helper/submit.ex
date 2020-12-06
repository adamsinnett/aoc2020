defmodule Submit do
  def submit(answer, year, day, part) do
    params = Params.parse(year, day)

    if part != "1" and part != "2", do: throw("unknown part")

    submitted = Cache.readSubmitCache(params, part)

    case submitted[to_string(answer)] do
      nil -> doSubmit(params, part, answer, submitted)
      result -> result
    end
  end

  defp doSubmit(params, part, answer, submitted) do
    response = Client.postSubmit(params, part, answer)
    Cache.writeSubmitCache(Map.put(submitted, answer, response), params, part)
    response
  end
end
