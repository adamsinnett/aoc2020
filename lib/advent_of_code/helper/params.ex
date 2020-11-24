defmodule Params do
  defstruct [:year, :day]

  def parse(year, day) do
    date = Date.utc_today()

    params = %Params{year: year, day: day}

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
end
