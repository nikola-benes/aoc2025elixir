start = IO.read(:line) |> to_charlist |> Enum.find_index(& &1 == ?S)

IO.stream(:line)
|> Enum.reduce({%{start => 1}, 0}, fn line, {beams, splits} ->
  splitters =
    for {c, i} <- line |> to_charlist |> Stream.with_index,
      c == ?^, into: %MapSet{}, do: i

  beams
  |> Enum.reduce({%{}, splits}, fn {i, c}, {beams, splits} ->
    {b, s} =
      if i in splitters do
        {%{i - 1 => c, i + 1 => c}, 1}
      else
        {%{i => c}, 0}
      end

    {Map.merge(beams, b, fn _, c1, c2 -> c1 + c2 end), splits + s}
  end)
end)
|> then(fn {b, s} ->
  IO.puts(s)
  Map.values(b) |> Enum.sum |> IO.puts
end)
