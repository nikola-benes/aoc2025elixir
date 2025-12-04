defmodule Day04 do
  def n8({y, x}) do
    for dy <- -1..1, dx <- -1..1, {dy, dx} != {0, 0}, do: {y + dy, x + dx}
  end

  def remove_once(ns) do
    removed =
      ns
      |> Stream.filter(fn {_, c} -> c < 4 end)
      |> Enum.map(fn {p, _} -> p end)

    ns = Map.drop(ns, removed)

    ns =
      removed
      |> Stream.flat_map(&n8/1)
      |> Stream.filter(&Map.has_key?(ns, &1))
      |> Enum.frequencies
      |> Map.merge(ns, fn _, r, c -> c - r end)

    {length(removed), ns}
  end

  def remove_all(ns, acc \\ 0) do
    {removed, ns} = remove_once(ns)
    removed == 0 && acc || remove_all(ns, acc + removed)
  end
end

rolls =
  IO.stream(:line)
  |> Stream.with_index
  |> Stream.flat_map(fn {line, y} ->
    line |> to_charlist |> Stream.with_index(fn c, x -> {{y, x}, c} end)
  end)
  |> Stream.filter(fn {_, c} -> c == ?@ end)
  |> MapSet.new(fn {p, _} -> p end)

ns =
  Map.new(
    rolls,
    fn p -> {p, Enum.count(Day04.n8(p), & &1 in rolls)} end
  )

ns |> Enum.count(fn {_, c} -> c < 4 end) |> IO.puts

Day04.remove_all(ns) |> IO.puts
