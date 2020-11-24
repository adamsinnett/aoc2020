defmodule AocInput do
  defstruct [:year, :day]

  def getInput(year, day) do
    session = getSession()
    params = getInputParams(year, day)

    case getCachedInput(params) do
      nil ->
        getAoCInput(params, session)
        |> parseInput
        |> cacheInput(params)

      input ->
        input
    end
  end

  defp cacheInput(input, params) do
    File.write!(getCacheFile(params), input)
    input
  end

  defp parseInput(%HTTPoison.Response{status_code: 200, body: body}) do
    body
  end

  defp parseInput(%HTTPoison.Response{status_code: status, body: body}) do
    throw("AOC website rejected us with status #{status} for #{body}")
  end

  defp getAoCInput(params, session) do
    HTTPoison.start()

    HTTPoison.get!("https://adventofcode.com/#{params.year}/day/#{params.day}/input", %{},
      hackney: [cookie: ["session=#{session}"]]
    )
  end

  defp getCachedInput(params) do
    case File.read(getCacheFile(params)) do
      {:ok, input} -> input
      _ -> nil
    end
  end

  defp getCacheFile(params) do
    "data/input/#{params.year}_#{params.day}.txt"
  end

  defp getInputParams(year, day) do
    date = Date.utc_today()

    params = %AocInput{year: year, day: day}

    if is_nil(params.year) do
      %{params | year: date.year}
    end

    if is_nil(params.day) do
      if params.year == date.year and date.month == 12 do
        %{params | day: date.day}
      else
        throw("I can't figure out what day you want. Can you be explicit?")
      end
    else
      params
    end
  end

  defp getSession() do
    Application.get_env(:aoc, :aoc_session)
  end
end
