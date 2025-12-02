# Part 1: Try to be clever instead of brute force

bool_to_int = fn true -> 1; false -> 0 end

divmod = fn x, y ->
  d = Integer.floor_div(x, y)
  {d, x - d * y}
end

gen_invalid = fn [from, to] ->
  len = String.length(from)
  to = String.to_integer(to)
  {half_len, m} = divmod.(len, 2)

  if m == 1 do
    Integer.pow(10, half_len)
  else
    {fl, fr} = String.split_at(from, half_len)
    String.to_integer(fl) + bool_to_int.(fl < fr)
  end
  |> Stream.iterate(& &1 + 1)
  |> Stream.map(fn x ->
    s = to_string(x)
    String.to_integer(s <> s)
  end)
  |> Stream.take_while(& &1 <= to)
end

numbers =
  IO.read(:line)
  |> String.trim()
  |> String.split(["-", ","])

numbers
|> Stream.chunk_every(2)
|> Stream.flat_map(gen_invalid)
|> Enum.sum
|> IO.puts

# Part 2: Brute force

numbers
|> Stream.map(&String.to_integer/1)
|> Stream.chunk_every(2)
|> Stream.flat_map(fn [a, b] -> a..b end)
|> Stream.filter(& to_string(&1) =~ ~r/^(.*)(\1)+$/)
|> Enum.sum
|> IO.puts
