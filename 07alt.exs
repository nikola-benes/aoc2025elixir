start = IO.read(:line) |> to_charlist |> Enum.find_index(& &1 == ?S)

for line <- IO.stream(:line),
    {c, i} <- line |> to_charlist |> Stream.with_index,
    c == ?^,
    reduce: {%{start => 1}, 0} do
  {%{^i => c} = beams, splits} ->
    {
      beams
      |> Map.delete(i)
      |> Map.merge(%{i - 1 => c, i + 1 => c}, fn _, c1, c2 -> c1 + c2 end),
      splits + 1
    }

  other -> other
end
|> then(fn {b, s} ->
  IO.puts(s)
  Map.values(b) |> Enum.sum |> IO.puts
end)
