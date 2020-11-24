defmodule Cache do
  def inputExists?(params) do
    File.exists?(getInputFilename(params))
  end

  def writeInputCache(input, params) do
    File.write!(getInputFilename(params), input)
  end

  def readInputCache(params) do
    File.read!(getInputFilename(params))
  end

  defp getInputFilename(params) do
    "#{getBaseDataDir()}/input/#{params.year}_#{params.day}.txt"
  end

  defp getSubmitFilename(params) do
    "#{getBaseDataDir()}/submit/#{params.year}_#{params.day}.txt"
  end

  defp getBaseDataDir() do
    dir = Application.get_env(:aoc, :aoc_cache, 'data')

    if not File.dir?(dir) do
      File.mkdir!(dir)
    end

    dir
  end
end
