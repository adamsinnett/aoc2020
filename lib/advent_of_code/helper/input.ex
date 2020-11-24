defmodule Input do
  def getInput(year, day) do
    params = Params.parse(year, day)

    if not Cache.inputExists?(params) do
      Client.getInput(params)
      |> Cache.writeInputCache(params)
    end

    Cache.readInputCache(params)
  end
end
