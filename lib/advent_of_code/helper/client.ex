defmodule Client do
  def getInput(params) do
    getInputUrl(params)
    |> doInput
  end

  def postSubmit(params, part, answer) do
    getSubmitUrl(params)
    |> doSubmit(part, answer)
    |> parseSubmit
  end

  defp doInput(url) do
    HTTPoison.start()
    resp = HTTPoison.get!(url, %{}, hackney: [cookie: ["session=#{getSession()}"]])

    case resp do
      %HTTPoison.Response{status_code: 200, body: body} ->
        body

      %HTTPoison.Response{status_code: status, body: body} ->
        throw("AOC website rejected us with status #{status} for #{body}")
    end
  end

  defp doSubmit(url, part, answer) do
    body = URI.encode_query(%{"level" => part, "answer" => answer})

    resp =
      HTTPoison.post!(
        url,
        body,
        %{"Content-Type" => "application/x-www-form-urlencoded"}
      )

    case resp do
      %HTTPoison.Response{status_code: 200, body: body} ->
        body

      %HTTPoison.Response{status_code: status, body: body} ->
        throw("AOC website rejected us with status #{status} for #{body}")
    end
  end

  defp parseSubmit(response) do
    cond do
      response =~ "That's not the right answer" -> {:error}
      true -> {:ok}
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
    Application.get_env(:aoc, :aoc_session)
  end
end
