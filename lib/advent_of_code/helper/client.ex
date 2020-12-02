defmodule Client do
  def getInput(params) do
    HTTPoison.start()

    resp =
      getInputUrl(params)
      |> HTTPoison.get!(%{}, hackney: [cookie: ["session=#{getSession()}"]])

    case resp do
      %HTTPoison.Response{status_code: 200, body: body} ->
        body

      %HTTPoison.Response{status_code: status, body: body} ->
        throw("AOC website rejected us with status #{status} for #{body}")
    end
  end

  def postSubmit(params, part, answer) do
    HTTPoison.start()

    resp =
      getSubmitUrl(params)
      |> HTTPoison.post!(
        URI.encode_query(%{"level" => part, "answer" => answer}),
        %{"Content-Type" => "application/x-www-form-urlencoded"},
        hackney: [cookie: ["session=#{getSession()}"]]
      )

    case resp do
      %HTTPoison.Response{status_code: 200, body: body} ->
        parseSubmit(body)

      %HTTPoison.Response{status_code: status, body: body} ->
        throw("AOC website rejected us with status #{status} for #{body}")
    end
  end

  defp parseSubmit(response) do
    cond do
      response =~ "That's not the right answer" -> :error
      true -> :ok
    end
  end

  defp getInputUrl(params) do
    "#{getUrl(params)}/input"
  end

  defp getSubmitUrl(params) do
    "#{getUrl(params)}/answer"
  end

  defp getUrl(params) do
    "https://adventofcode.com/#{params.year}/day/#{params.day}"
  end

  defp getSession() do
    Application.get_env(:advent_of_code, :aoc_session)
  end
end
