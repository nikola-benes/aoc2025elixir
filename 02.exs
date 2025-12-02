# Try to be clever in both parts

divmod = fn x, y ->
  d = Integer.floor_div(x, y)
  {d, x - d * y}
end

gen_invalid = fn ft, r ->
  from_s = hd(ft)
  len = String.length(from_s)
  [from, to] = Enum.map(ft, &String.to_integer/1)
  {chunk_len, m} = divmod.(len, r)

  if m != 0 do
    Integer.pow(10, chunk_len)
  else
    String.slice(from_s, 0, chunk_len) |> String.to_integer
  end
  |> Stream.iterate(& &1 + 1)
  |> Stream.map(& to_string(&1) |> String.duplicate(r) |> String.to_integer)
  |> Stream.drop_while(& &1 < from)
  |> Stream.take_while(& &1 <= to)
end

ranges =
  IO.read(:line)
  |> String.trim()
  |> String.split(["-", ","])
  |> Stream.chunk_every(2)

part1 = ranges |> Stream.flat_map(&gen_invalid.(&1, 2))

part2 =
  ranges
  |> Stream.flat_map(fn [from, to] ->
    2..String.length(to)
    |> Stream.flat_map(&gen_invalid.([from, to], &1))
    |> Stream.uniq
  end)

for p <- [part1, part2], do: p |> Enum.sum |> IO.puts
