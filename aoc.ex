defmodule Aoc do
  defmacro e ~> f do
    quote do
      unquote(e) |> Stream.map(fn x -> x |> unquote(f) end)
    end
  end

  def stream_chunk_only(e, f) when is_function(f, 1) do
    e |> Stream.chunk_by(f) |> Stream.filter(fn [x | _] -> f.(x) end)
  end
end
