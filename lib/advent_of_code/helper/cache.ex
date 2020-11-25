defmodule Cache do
  def inputExists?(params) do
    getInputFilename(params)
    |> File.exists?()
  end

  def writeInputCache(input, params) do
    getInputFilename(params)
    |> File.write!(input)
  end

  def readInputCache(params) do
    getInputFilename(params)
    |> File.read!()
  end

  defp getInputFilename(params) do
    "#{getBaseDataDir()}/input/#{params.year}_#{params.day}.txt"
  end

  defp getSubmitFilename(params) do
    "#{getBaseDataDir()}/submit/#{params.year}_#{params.day}.txt"
  end

  defp getBaseDataDir() do
    dir = Application.get_env(:advent_of_code, :aoc_cache, 'data')

    if not File.dir?(dir) do
      File.mkdir!(dir)
    end

    dir
  end
end
