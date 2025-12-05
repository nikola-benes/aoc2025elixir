defmodule Aoc do
  defmacro e ~> f do
    quote do
      unquote(e) |> Stream.map(fn x -> x |> unquote(f) end)
    end
  end
end
